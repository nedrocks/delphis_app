import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/discussion_access.dart';
import 'package:delphis_app/data/repository/discussion_subscription.dart';
import 'package:delphis_app/data/repository/entity.dart';
import 'package:delphis_app/data/repository/media.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:delphis_app/data/repository/post_content_input.dart';
import 'package:delphis_app/tracking/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:meta/meta.dart';

part 'discussion_event.dart';
part 'discussion_state.dart';

class DiscussionBloc extends Bloc<DiscussionEvent, DiscussionState> {
  final DiscussionRepository discussionRepository;
  final MediaRepository mediaRepository;

  DiscussionBloc({
    @required this.discussionRepository,
    @required this.mediaRepository,
  }) : super(DiscussionUninitializedState());

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

  int getConciergeStep(Discussion discussion) {
    if (discussion.postsCache != null) {
      for (int i = 0; i < discussion.postsCache.length; i++) {
        if (discussion.postsCache[i].postType == PostType.CONCIERGE) {
          // We may want to keep state in the future.
          return 0;
        }
      }
    }
    return null;
  }

  @override
  Stream<DiscussionState> mapEventToState(DiscussionEvent event) async* {
    var currentState = this.state;
    if (event is DiscussionClearEvent) {
      yield DiscussionUninitializedState();
    } else if (event is DiscussionQueryEvent &&
        !(currentState is DiscussionLoadingState)) {
      try {
        yield DiscussionLoadingState();
        var discussion =
            await discussionRepository.getDiscussion(event.discussionID);
        int conciergeStep = getConciergeStep(discussion);
        if (discussion.isMeDiscussionModerator()) {
          final discussionAccessLink = await discussionRepository
              .getDiscussionAccessLink(event.discussionID);
          discussion =
              discussion.copyWith(discussionAccessLink: discussionAccessLink);
        }
        yield DiscussionLoadedState(
          discussion: discussion,
          lastUpdate: DateTime.now(),
          onboardingConciergeStep: conciergeStep,
        );
      } catch (err) {
        yield DiscussionErrorState(err);
      }
    } else if (event is RefreshPostsEvent &&
        currentState is DiscussionLoadedState &&
        currentState.discussion.id == event.discussionID) {
      try {
        final updatedState = currentState.update(isLoading: true);
        yield updatedState;
        final updatedDiscussion = await discussionRepository
            .getDiscussion(currentState.discussion.id);
        yield updatedState.update(
            discussion: updatedDiscussion, isLoading: false);
      } catch (err) {
        // Not sure what to do here... it failed but need to capture it somehow.
        yield currentState;
      }
    } else if (event is LoadPreviousPostsPageEvent &&
        currentState is DiscussionLoadedState &&
        currentState.discussion.id == event.discussionID &&
        !currentState.isLoading) {
      try {
        final updatedState = currentState.update(isLoading: true);
        yield updatedState;
        final newPostsConnection = await discussionRepository
            .getDiscussionPostsConnection(currentState.discussion.id,
                postsConnection: currentState.discussion.postsConnection);
        final updatedDiscussion = currentState.discussion.copyWith(
            postsConnection: newPostsConnection,
            postsCache: currentState.discussion.postsCache +
                newPostsConnection.asPostList());
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
              mentionedEntities: event.localMentionedEntities
                  .map((e) => Entity(id: e))
                  .toList(), // Hacky, but it wserves its purpose
              isLocalPost: true,
              localMediaFile: event.media,
              localMediaContentType: event.mediaContentType),
        );
        currentState.getDiscussion().addLocalPost(localPost);
        currentState.localPosts[localPost.key] = localPost;
        yield currentState.update(
            discussion: currentState.getDiscussion(),
            localPosts: currentState.localPosts);

        /* Try to upload the media file */
        String mediaId;
        if (event.media != null && event.mediaContentType != null) {
          try {
            MediaUpload uploadedMedia =
                await mediaRepository.uploadImage(event.media);
            if (uploadedMedia.mediaId != null) mediaId = uploadedMedia.mediaId;
          } catch (error) {
            Segment.track(
                eventName: ChathamTrackingEventNames.POST_ADD,
                properties: {
                  'funnelID': event.uniqueID,
                  'error': true,
                  'success': false,
                  'discussionID': currentState.getDiscussion().id,
                  'participantID':
                      currentState.getDiscussion().meParticipant.id,
                  'contentLength': event.postContent.length,
                });
            this.add(LocalPostCreateFailure(localPost: localPost));
          }
        }

        /* Proceed in sending post */
        if (mediaId != null ||
            (event.media == null && event.mediaContentType == null)) {
          this
              .discussionRepository
              .addPost(
                  discussion: currentState.getDiscussion(),
                  participantID: currentState.getDiscussion().meParticipant.id,
                  postContent: event.postContent,
                  mentionedEntities: event.mentionedEntities,
                  preview: event.preview,
                  mediaId: mediaId)
              .then((addedPost) {
            final success = addedPost != null;
            Segment.track(
                eventName: ChathamTrackingEventNames.POST_ADD,
                properties: {
                  'funnelID': event.uniqueID,
                  'error': false,
                  'success': success,
                  'discussionID': currentState.getDiscussion().id,
                  'participantID':
                      currentState.getDiscussion().meParticipant.id,
                  'contentLength': event.postContent.length,
                });
            if (addedPost == null) {
              // The response may not be a post if it's malformed or something.
              this.add(LocalPostCreateFailure(localPost: localPost));
              return;
            }

            /* The post content may have changed during submission
              (This appens with mentions, for instance). This adds resistence in case
              the content mutation happens either in the frontend or the backend. */
            localPost.post = localPost.post.copyWith(
                content: addedPost.content,
                mentionedEntities: addedPost.mentionedEntities,
                media: addedPost.media);
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
                  'participantID':
                      currentState.getDiscussion().meParticipant.id,
                  'contentLength': event.postContent.length,
                });
            localPost.isProcessing = false;
            localPost.failCount += 1;
            localPost.isFailed = true;
            this.add(LocalPostCreateFailure(localPost: localPost));
          });
        }
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
    } else if (event is DiscussionPostDeletedEvent &&
        currentState is DiscussionLoadedState) {
      final discussion = currentState.getDiscussion();
      if (discussion != null) {
        var newPostsCache = discussion.postsCache.map((p) {
          if (p.id == event.post.id) return event.post;
          return p;
        }).toList();
        var updatedDiscussion = currentState.getDiscussion().copyWith(
              postsCache: newPostsCache,
            );
        yield currentState.update(discussion: updatedDiscussion);
      }
    } else if (event is DiscussionParticipantBannedEvent &&
        currentState is DiscussionLoadedState) {
      final discussion = currentState.getDiscussion();
      if (discussion != null) {
        var newParticipants = discussion.participants.map((p) {
          if (p.id == event.participant.id) return event.participant;
          return p;
        }).toList();
        var newPostsCache = discussion.postsCache.map((p) {
          if (p.participant.id == event.participant.id)
            return p.copyWith(
                isDeleted: true,
                deletedReasonCode: PostDeletedReason.PARTICIPANT_REMOVED);
          return p;
        }).toList();
        var updatedDiscussion = currentState
            .getDiscussion()
            .copyWith(postsCache: newPostsCache, participants: newParticipants);
        yield currentState.update(discussion: updatedDiscussion);
      }
    } else if (event is SubscribeToDiscussionEvent &&
        currentState is DiscussionLoadedState) {
      if (currentState.getDiscussion() != null &&
          currentState.discussionPostStream == null) {
        final discussionStream = await this
            .discussionRepository
            .subscribe(currentState.getDiscussion().id);
        discussionStream.listen(this.consumeDiscussionSubscriptionEvent);
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
    } else if (event is LoadLocalDiscussionEvent) {
      // This might be used for local cached copies too eventually
      yield DiscussionLoadedState(
          discussion: event.discussion,
          lastUpdate: DateTime.now(),
          onboardingConciergeStep: getConciergeStep(event.discussion));
    } else if (event is DiscussionConciergeOptionSelectedEvent &&
        currentState is DiscussionLoadedState &&
        currentState.discussion.id == event.discussionID) {
      final loadingState = currentState.update(isLoading: true);
      yield loadingState;
      try {
        final updatedPost = await this
            .discussionRepository
            .selectConciergeMutation(
                event.discussionID, event.mutationID, event.selectedOptionIDs);
        final postsCache = loadingState.discussion.postsCache;
        for (int i = 0; i < postsCache.length; i++) {
          if (postsCache[i].id == updatedPost.id) {
            postsCache[i] = updatedPost;
            break;
          }
        }
        yield loadingState.update(
            isLoading: false,
            onboardingConciergeStep:
                loadingState.onboardingConciergeStep == null
                    ? 0
                    : loadingState.onboardingConciergeStep + 1);
      } catch (err) {
        yield loadingState.update(isLoading: false);
      }
    } else if (event is DiscussionShowOnboardingEvent &&
        currentState is DiscussionLoadedState &&
        currentState.discussion.id == event.discussionID) {
      yield currentState.update(onboardingConciergeStep: 0);
    } else if (event is NextDiscussionOnboardingConciergeStep &&
        currentState is DiscussionLoadedState) {
      yield currentState.update(
          onboardingConciergeStep: currentState.onboardingConciergeStep == null
              ? 0
              : currentState.onboardingConciergeStep + 1);
    } else if (event is DiscussionUpdateEvent &&
        currentState is DiscussionLoadedState &&
        currentState.discussion.id == event.discussionID) {
      final loadingState = currentState.update(isLoading: true);
      yield loadingState;
      try {
        final updatedDiscussion =
            await this.discussionRepository.updateDiscussion(
                  event.discussionID,
                  DiscussionInput(
                    title: event.title,
                    description: event.description,
                    iconURL: event.selectedEmoji == null
                        ? null
                        : "emoji://${event.selectedEmoji}",
                  ),
                );
        yield loadingState.update(
          isLoading: false,
          discussion: updatedDiscussion,
        );
      } catch (err) {
        yield loadingState.update(isLoading: false);
      }
    } else if (event is DiscussionParticipantsMutedUnmutedEvent &&
        currentState is DiscussionLoadedState) {
      final discussion = currentState.getDiscussion();
      if (discussion != null) {
        var newParticipants = discussion.participants.map((p) {
          for (var participant in event.participants) {
            if (p.id == participant.id) {
              return participant;
            }
          }
          return p;
        }).toList();
        var updatedDiscussion = currentState
            .getDiscussion()
            .copyWith(participants: newParticipants);
        yield currentState.update(discussion: updatedDiscussion);
      }
    } else if (event is DiscussionMuteEvent &&
        currentState is DiscussionLoadedState) {
      if (currentState.discussion.id != event.discussionID) {
        return;
      }
      final localUpdatedDiscussion = currentState.discussion.copyWith(
        meNotificationSettings: event.isMute
            ? DiscussionUserNotificationSetting.NONE
            : DiscussionUserNotificationSetting.EVERYTHING,
      );
      yield currentState.update(discussion: localUpdatedDiscussion);
      try {
        await this.discussionRepository.updateDiscussionUserSettings(
            event.discussionID,
            null,
            event.isMute
                ? DiscussionUserNotificationSetting.NONE
                : DiscussionUserNotificationSetting.EVERYTHING);
      } catch (err) {
        // In the error case we need to roll back the discussion notification
        // status and post an error to the user.
        yield currentState;
      }
    } else if (event is RequestDiscussionAccessEvent &&
        currentState is DiscussionLoadedState) {
      try {
        await this
            .discussionRepository
            .requestDiscussionAccess(currentState.discussion.id);
        final updatedDiscussion = currentState.discussion.copyWith(
          meCanJoinDiscussion: CanJoinDiscussionResponse(
              response: DiscussionJoinabilityResponse.AWAITING_APPROVAL),
        );
        yield currentState.update(discussion: updatedDiscussion);
      } catch (err) {}
    }
  }

  void consumeDiscussionSubscriptionEvent(DiscussionSubscriptionEvent event) {
    if (event is DiscussionSubscriptionPostAdded) {
      this.add(DiscussionPostAddedEvent(post: event.post));
    } else if (event is DiscussionSubscriptionPostDeleted) {
      this.add(DiscussionPostDeletedEvent(post: event.post));
    } else if (event is DiscussionSubscriptionParticipantBanned) {
      this.add(
          DiscussionParticipantBannedEvent(participant: event.participant));
    }
  }
}
