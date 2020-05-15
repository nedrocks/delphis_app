import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
    } else if (event is DiscussionPostsUpdatedEvent) {
      if (currentState.getDiscussion() != null) {
        final updatedDiscussion =
            currentState.getDiscussion().copyWith(posts: event.posts);
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
        print('pre adding local: ${currentState.getDiscussion().posts.length}');
        currentState.getDiscussion().addLocalPost(localPost);
        currentState.localPosts[localPost.key] = localPost;
        print(
            'about to yield with num posts: ${currentState.getDiscussion().posts.length}');
        yield currentState.update(
            discussion: currentState.getDiscussion(),
            localPosts: currentState.localPosts);
        this
            .repository
            .addPost(currentState.getDiscussion().id, event.postContent)
            .then((addedPost) {
          // The current state may have changed since this is a future.
          this.add(LocalPostCreateSuccess(
              createdPost: addedPost, localPost: localPost));
        }, onError: (err) {
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
        for (int i = 0; i < discussion.posts.length; i++) {
          if (discussion.posts[i].id == event.post.id) {
            found = true;
            break;
          } else if (discussion.posts[i]
              .createdAtAsDateTime()
              .isBefore(event.post.createdAtAsDateTime())) {
            found = false;
            break;
          }
        }
        if (!found || !isParticipantFound) {
          // This post is new.
          var updatedPosts = discussion.posts;
          var participants = discussion.participants;
          if (!found) {
            updatedPosts.insert(0, event.post);
          }
          if (!isParticipantFound) {
            participants.add(event.post.participant);
          }
          var updatedDiscussion = currentState.getDiscussion().copyWith(
                posts: updatedPosts,
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
      print('in local post create success');
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
      print('this failed.');
      // This _should_ have pointers to the correct place.
      yield currentState.update(
        discussion: currentState.discussion,
        localPosts: currentState.localPosts,
      );
    }
  }
}
