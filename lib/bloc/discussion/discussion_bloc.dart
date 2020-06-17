import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:delphis_app/tracking/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:meta/meta.dart';

part 'discussion_event.dart';
part 'discussion_state.dart';

class DiscussionBloc extends Bloc<DiscussionEvent, DiscussionState> {
  final DiscussionRepository repository;

  DiscussionBloc({
    @required this.repository,
  }) : super();

  @override
  DiscussionState get initialState => DiscussionUninitializedState();

  bool isLikelyPendingPost(
      DiscussionLoadedState state, Discussion discussion, Post post) {
    // Checks if the post is a likely pending post. This happens if the post
    // is either by the current participant and there are local posts pending
    // and the text matches the exact text of a local pending post.
    if (state.localPosts.length == 0) {
      return false;
    }
    LocalPost foundLocalPost;
    for (final localPost in state.localPosts.values) {
      if (localPost != null && localPost.post.content == post.content) {
        foundLocalPost = localPost;
      }
    }
    if (foundLocalPost == null) {
      return false;
    }
    if (!foundLocalPost.isProcessing) {
      return false;
    }
    if (post.participant?.id != null) {
      // Effectively: For all the available participants to the current user
      // does one of their IDs match the post we're about to add?
      if (discussion.meAvailableParticipants != null &&
          discussion.meAvailableParticipants.length > 0) {
        for (final participant in discussion.meAvailableParticipants) {
          if (participant.id == post.participant.id) {
            return true;
          }
        }
      }
    }
    // This is a very strange case that we should track when it happens. I think
    // someting like copy/pasta could cause this.
    return false;
  }

  @override
  Stream<DiscussionState> mapEventToState(DiscussionEvent event) async* {
    var currentState = this.state;
    if (event is DiscussionQueryEvent &&
        !(currentState is DiscussionLoadingState)) {
      try {
        yield DiscussionLoadingState();
        final discussion = await repository.getDiscussion(event.discussionID);
        yield DiscussionLoadedState(
            discussion: discussion, lastUpdate: DateTime.now());
      } catch (err) {
        yield DiscussionErrorState(err);
      }
    } else if (event is RefreshPostsEvent &&
        currentState is DiscussionLoadedState &&
        currentState.discussion.id == event.discussionID) {
      try {
        final updatedState = currentState.update(isLoading: true);
        yield updatedState;
        final updatedDiscussion =
            await repository.getDiscussion(currentState.discussion.id);
        yield updatedState.update(
            discussion: updatedDiscussion, isLoading: false);
      } catch (err) {
        // Not sure what to do here... it failed but need to capture it somehow.
        yield currentState;
      }
    } else if (event is LoadPreviousPostsPageEvent &&
        currentState is DiscussionLoadedState &&
        currentState.discussion.id == event.discussionID
        && !currentState.isLoading) {
      try {
        final updatedState = currentState.update(isLoading: true);
        yield updatedState;
        final newPostsConnection = await repository.getDiscussionPostsConnection(currentState.discussion.id,
            postsConnection: currentState.discussion.postsConnection);
        final updatedDiscussion = currentState.discussion.copyWith(postsConnection: newPostsConnection,
          postsCache: currentState.discussion.postsCache + newPostsConnection.asPostList());
        yield updatedState.update(
            discussion: updatedDiscussion, isLoading: false);
      } catch (err) {
        // Not sure what to do here... it failed but need to capture it somehow.
        yield currentState;
      }
    } else if (event is DiscussionPostsUpdatedEvent) {
      if (currentState.getDiscussion() != null) {
        final updatedDiscussion =
            currentState.getDiscussion().copyWith(postsCache: event.posts);
        var newState = DiscussionLoadedState(
            discussion: updatedDiscussion, lastUpdate: DateTime.now());
        yield newState;
      }
    } else if (event is MeParticipantUpdatedEvent) {
      if (currentState.getDiscussion() != null) {
        final updatedDiscussion = currentState
            .getDiscussion()
            .copyWith(meParticipant: event.meParticipant);
        yield DiscussionLoadedState(
            discussion: updatedDiscussion, lastUpdate: DateTime.now());
      }
    } else if (event is DiscussionPostAddEvent &&
        currentState is DiscussionLoadedState) {
      if (currentState.getDiscussion() != null) {
        final localPostKey = GlobalKey();
        final localPost = LocalPost(
          key: localPostKey,
          isProcessing: true,
          failCount: 0,
          isFailed: false,
          post: Post(
            id: localPostKey.toString(),
            discussion: currentState.getDiscussion(),
            participant: currentState.getDiscussion().meParticipant,
            content: event.postContent,
            isLocalPost: true,
          ),
        );
        currentState.getDiscussion().addLocalPost(localPost);
        currentState.localPosts[localPost.key] = localPost;
        yield currentState.update(
            discussion: currentState.getDiscussion(),
            localPosts: currentState.localPosts);
        this
            .repository
            .addPost(
                discussionID: currentState.getDiscussion().id,
                participantID: currentState.getDiscussion().meParticipant.id,
                postContent: event.postContent)
            .then((addedPost) {
          final success = addedPost != null;
          Segment.track(
              eventName: ChathamTrackingEventNames.POST_ADD,
              properties: {
                'funnelID': event.uniqueID,
                'error': false,
                'success': success,
                'discussionID': currentState.getDiscussion().id,
                'participantID': currentState.getDiscussion().meParticipant.id,
                'contentLength': event.postContent.length,
              });
          if (addedPost == null) {
            // The response may not be a post if it's malformed or something.
            this.add(LocalPostCreateFailure(localPost: localPost));
            return;
          }
          // The current state may have changed since this is a future.
          this.add(LocalPostCreateSuccess(
              createdPost: addedPost, localPost: localPost));
        }, onError: (err) {
          Segment.track(
              eventName: ChathamTrackingEventNames.POST_ADD,
              properties: {
                'funnelID': event.uniqueID,
                'error': true,
                'success': false,
                'discussionID': currentState.getDiscussion().id,
                'participantID': currentState.getDiscussion().meParticipant.id,
                'contentLength': event.postContent.length,
              });
          localPost.isProcessing = false;
          localPost.failCount += 1;
          localPost.isFailed = true;
          this.add(LocalPostCreateFailure(localPost: localPost));
        });
      }
    } else if (event is DiscussionPostAddedEvent &&
        currentState is DiscussionLoadedState) {
      if (currentState.getDiscussion() != null) {
        // This is pretty gross.
        var found = false;
        final discussion = currentState.getDiscussion();
        if (this.isLikelyPendingPost(currentState, discussion, event.post)) {
          // In this case there should be a local post here. I know this is
          // introducing a potential issue if the local post flow breaks down
          // but I think this is a relatively safe approach
          return;
        }
        var isParticipantFound = false;
        final participants = discussion.participants;
        for (int i = 0; i < discussion.participants.length; i++) {
          if (discussion.participants[i].id == event.post.participant.id) {
            isParticipantFound = true;
            break;
          }
        }
        if (!isParticipantFound) {
          participants.add(event.post.participant);
        }
        for (int i = 0; i < discussion.postsCache.length; i++) {
          if (discussion.postsCache[i].id == event.post.id) {
            found = true;
            break;
          } else if (discussion.postsCache[i]
              .createdAtAsDateTime()
              .isBefore(event.post.createdAtAsDateTime())) {
            found = false;
            break;
          }
        }
        if (!found || !isParticipantFound) {
          // This post is new.
          var updatedPosts = discussion.postsCache;
          var participants = discussion.participants;
          if (!found) {
            updatedPosts.insert(0, event.post);
          }
          if (!isParticipantFound) {
            participants.add(event.post.participant);
          }
          var updatedDiscussion = currentState.getDiscussion().copyWith(
                postsCache: updatedPosts,
                participants: participants,
              );
          yield currentState.update(discussion: updatedDiscussion);
        }
      }
    } else if (event is SubscribeToDiscussionEvent &&
        currentState is DiscussionLoadedState) {
      if (currentState.getDiscussion() != null &&
          currentState.discussionPostStream == null) {
        final discussionStream =
            await this.repository.subscribe(currentState.getDiscussion().id);
        discussionStream.listen((Post post) {
          this.add(DiscussionPostAddedEvent(post: post));
        });
        yield currentState.update(stream: discussionStream);
      }
    } else if (event is LocalPostCreateSuccess &&
        currentState is DiscussionLoadedState) {
      final discussion = currentState.getDiscussion();
      // The discussion may have changed.
      if (discussion != null &&
          discussion.id == event.localPost.post.discussion.id) {
        final didReplace =
            discussion.replaceLocalPost(event.createdPost, event.localPost.key);
        if (didReplace) {
          final localPosts = currentState.localPosts;
          localPosts.remove(event.localPost.key);
          yield currentState.update(
              discussion: discussion, localPosts: localPosts);
        }
      }
    } else if (event is LocalPostCreateFailure &&
        currentState is DiscussionLoadedState) {
      // This _should_ have pointers to the correct place.
      yield currentState.update(
        discussion: currentState.discussion,
        localPosts: currentState.localPosts,
      );
    } else if (event is NewDiscussionEvent) {
      final originalState = currentState;
      yield AddingDiscussionState(
          anonymityType: event.anonymityType, title: event.title);
      try {
        final discussion = await this.repository.createDiscussion(
            title: event.title, anonymityType: event.anonymityType);
        yield DiscussionLoadedState(
            discussion: discussion, lastUpdate: DateTime.now());
      } catch (err) {
        // TODO: We should probably say that we failed somewhere.
        yield originalState;
      }
    }
  }
}
