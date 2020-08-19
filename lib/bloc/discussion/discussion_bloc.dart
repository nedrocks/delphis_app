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
      if (currentState is DiscussionLoadedState &&
          currentState.discussionPostListener != null) {
        currentState.discussionPostListener.cancel();
      }
      yield DiscussionUninitializedState();
    } else if (event is DiscussionQueryEvent &&
        !(currentState is DiscussionLoadingState)) {
      try {
        if (currentState is DiscussionLoadedState &&
            currentState.discussionPostListener != null) {
          currentState.discussionPostListener.cancel();
        }
        yield DiscussionLoadingState();
        var discussion =
            await discussionRepository.getDiscussion(event.discussionID);
        int conciergeStep = getConciergeStep(discussion);
        if (discussion.isMeDiscussionModerator()) {
          final modOnly = await discussionRepository
              .getDiscussionModOnlyFields(event.discussionID);
          discussion = discussion.copyWith(
            discussionAccessLink: modOnly.discussionAccessLink,
            accessRequests: modOnly.accessRequests,
          );
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
        currentState is DiscussionLoadedState &&
        currentState.getDiscussion() != null) {
      /* Create a local post */
      final localPost = LocalPost(
        isProcessing: true,
        post: Post(
          isLocalPost: true,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
          discussion: currentState.getDiscussion(),
          participant: currentState.getDiscussion().meParticipant,
          content: event.postContent,
          mentionedEntities: event.localMentionedEntities
              .map((e) => Entity(id: e))
              .toList(), // Hacky, but it wserves its purpose
          localMediaFile: event.media,
          localMediaContentType: event.mediaContentType,
        ),
      );

      /* Add it to the current cached list in advance as a preview to the user */
      currentState.getDiscussion().postsCache.insert(0, localPost.post);
      currentState.localPosts.add(localPost);
      yield currentState.update(
        discussion: currentState.getDiscussion(),
        localPosts: currentState.localPosts,
      );

      /* Proceed by sending the post */
      try {
        /* Attempt to upload the media file first */
        String mediaId;
        if (event.media != null && event.mediaContentType != null) {
          MediaUpload uploadedMedia =
              await mediaRepository.uploadImage(event.media);
          if (uploadedMedia.mediaId == null) {
            throw "Image upload failed";
          }
          mediaId = uploadedMedia.mediaId;
        }

        /* Actual attempt to add the new post to the discussion */
        var newPost = await this.discussionRepository.addPost(
              discussion: currentState.getDiscussion(),
              participantID: currentState.getDiscussion().meParticipant.id,
              postContent: event.postContent,
              mentionedEntities: event.mentionedEntities,
              preview: event.preview,
              mediaId: mediaId,
            );
        if (newPost == null) {
          throw "Something went wrong while adding the post";
        }

        /* Update local cached lists with new post */
        currentState.getDiscussion().postsCache.remove(localPost.post);
        currentState.getDiscussion().postsCache.insert(0, newPost);
        currentState.localPosts.remove(localPost);

        /* Yeld new updated state */
        yield currentState.update(
          discussion: currentState.getDiscussion(),
          localPosts: currentState.localPosts,
        );

        /* Send event to analytics */
        Segment.track(
          eventName: ChathamTrackingEventNames.POST_ADD,
          properties: {
            'funnelID': event.uniqueID,
            'error': false,
            'success': true,
            'discussionID': currentState.getDiscussion().id,
            'participantID': currentState.getDiscussion().meParticipant.id,
            'contentLength': event.postContent.length,
          },
        );
      } catch (error) {
        /* Update local cached lists with error */
        currentState.localPosts.remove(localPost);
        currentState.localPosts.add(localPost.copyWith(
          isProcessing: false,
          error: error,
        ));

        /* Yield new state with error */
        yield currentState.update(
          discussion: currentState.discussion,
          localPosts: currentState.localPosts,
        );

        /* Send event to analytics */
        Segment.track(
          eventName: ChathamTrackingEventNames.POST_ADD,
          properties: {
            'funnelID': event.uniqueID,
            'error': true,
            'success': false,
            'discussionID': currentState.getDiscussion().id,
            'participantID': currentState.getDiscussion().meParticipant.id,
            'contentLength': event.postContent.length,
          },
        );
      }
    } else if (event is DiscussionPostReceivedEvent &&
        currentState is DiscussionLoadedState &&
        currentState.getDiscussion() != null) {
      final discussion = currentState.getDiscussion();
      final participants = discussion.participants;
      final postsCache = discussion.postsCache;
      var isPostFound = false;
      var isParticipantFound = false;

      /* Check if this participant is aleady part of the local list */
      for (int i = 0; i < discussion.participants.length; i++) {
        if (discussion.participants[i].id == event.post.participant.id) {
          isParticipantFound = true;
          break;
        }
      }
      if (!isParticipantFound) {
        participants.add(event.post.participant);
      }

      /* Check if this post is aleady part of the local list */
      for (int i = 0; i < discussion.postsCache.length; i++) {
        if (discussion.postsCache[i].id == event.post.id) {
          isPostFound = true;
          break;
        } else if (discussion.postsCache[i]
            .createdAtAsDateTime()
            .isBefore(event.post.createdAtAsDateTime())) {
          isPostFound = false;
          break;
        }
      }
      if (!isPostFound) {
        postsCache.insert(0, event.post);
      }

      yield currentState.update(
        discussion: discussion.copyWith(
          participants: participants,
          postsCache: postsCache,
        ),
      );
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
      if (currentState.getDiscussion() != null) {
        if (currentState.discussionPostListener != null) {
          currentState.discussionPostListener.cancel();
        }
        final discussionStream = await this
            .discussionRepository
            .subscribe(currentState.getDiscussion().id);
        // ignore: cancel_subscriptions
        final listener =
            discussionStream.listen(this.consumeDiscussionSubscriptionEvent);
        yield currentState.update(stream: discussionStream, listener: listener);
        this.add(RefreshPostsEvent(discussionID: event.discussionID));
      }
    } else if (event is UnsubscribeFromDiscussionEvent &&
        currentState is DiscussionLoadedState) {
      if (currentState.discussion.id == event.discussionID &&
          currentState.discussionPostListener != null) {
        currentState.discussionPostListener.cancel();
        yield currentState.update(listener: null, stream: null);
      }
    } else if (event is LoadLocalDiscussionEvent) {
      // This might be used for local cached copies too eventually
      yield DiscussionLoadedState(
          discussion: event.discussion,
          lastUpdate: DateTime.now(),
          onboardingConciergeStep: getConciergeStep(event.discussion));
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
    } else if (event is DiscussionRespondToAccessRequestEvent &&
        currentState is DiscussionLoadedState &&
        currentState.discussion.isMeDiscussionModerator()) {
      /* Execute this task asynchronously as the user might respond to
           many request very quickly so this has to be not blocking. */
      DiscussionAccessRequest currentAccessRequest;
      final updatedDiscussion = currentState.discussion.copyWith(
          accessRequests: currentState.discussion.accessRequests.map((e) {
        if (e.id == event.requestID) {
          currentAccessRequest = e;
          return e.copyWith(isLoadingLocally: true);
        }
        return e;
      }).toList());
      yield currentState.update(discussion: updatedDiscussion);
      if (currentAccessRequest != null) {
        () async {
          try {
            var accessRequest = await this
                .discussionRepository
                .respondToAccessRequest(event.requestID, event.status);
            this.add(_DiscussionRespondToAccessRequestAsyncEvent(
                accessRequest, null));
          } catch (error) {
            this.add(_DiscussionRespondToAccessRequestAsyncEvent(
                currentAccessRequest, error));
          }
        }();
      }
    } else if (event is _DiscussionRespondToAccessRequestAsyncEvent &&
        currentState is DiscussionLoadedState) {
      final updatedDiscussion = currentState.discussion.copyWith(
          accessRequests: currentState.discussion.accessRequests.map((e) {
        if (e.id == event.request.id) {
          if (event.error != null) {
            return e.copyWith(isLoadingLocally: false);
          } else {
            return event.request;
          }
        }
        return e;
      }).toList());
      yield currentState.update(discussion: updatedDiscussion);
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
      this.add(DiscussionPostReceivedEvent(post: event.post));
    } else if (event is DiscussionSubscriptionPostDeleted) {
      this.add(DiscussionPostDeletedEvent(post: event.post));
    } else if (event is DiscussionSubscriptionParticipantBanned) {
      this.add(
          DiscussionParticipantBannedEvent(participant: event.participant));
    }
  }
}
