part of 'discussion_bloc.dart';

@immutable
abstract class DiscussionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DiscussionQueryEvent extends DiscussionEvent {
  final String discussionID;
  final DateTime nonce;

  DiscussionQueryEvent({
    @required this.discussionID,
    this.nonce,
  }) : super();

  @override
  List<Object> get props => [this.discussionID, this.nonce];
}

class DiscussionErrorEvent extends DiscussionEvent {
  final Exception exception;

  DiscussionErrorEvent(this.exception) : super();

  @override
  List<Object> get props => [this.exception];
}

class DiscussionLoadedEvent extends DiscussionEvent {
  final Discussion discussion;

  DiscussionLoadedEvent(this.discussion) : super();

  @override
  List<Object> get props => [this.discussion];
}

class DiscussionPostsUpdatedEvent extends DiscussionEvent {
  final List<Post> posts;
  final DateTime timestamp;

  DiscussionPostsUpdatedEvent(this.posts, this.timestamp) : super();

  @override
  List<Object> get props => [this.posts, this.timestamp];
}

class MeParticipantUpdatedEvent extends DiscussionEvent {
  // Any of these may be null.
  final Participant meParticipant;

  MeParticipantUpdatedEvent({
    @required this.meParticipant,
  }) : super();

  @override
  List<Object> get props => [this.meParticipant];
}

class DiscussionPostAddEvent extends DiscussionEvent {
  final String preview;
  final String postContent;
  final String uniqueID;
  final List<String> mentionedEntities;
  final List<String> localMentionedEntities;
  final File media;
  final MediaContentType mediaContentType;

  @override
  List<Object> get props => [
        this.postContent,
        this.uniqueID,
        this.preview,
        this.mentionedEntities,
        this.localMentionedEntities
      ];

  DiscussionPostAddEvent(
      {@required this.postContent,
      @required this.uniqueID,
      @required this.mentionedEntities,
      @required this.localMentionedEntities,
      this.media,
      this.mediaContentType,
      this.preview})
      : super();
}

class DiscussionPostAddedEvent extends DiscussionEvent {
  final Post post;

  @override
  List<Object> get props => [this.post];

  DiscussionPostAddedEvent({
    @required this.post,
  }) : super();
}

class DiscussionPostDeletedEvent extends DiscussionEvent {
  final Post post;

  @override
  List<Object> get props => [this.post];

  DiscussionPostDeletedEvent({
    @required this.post,
  }) : super();
}

class DiscussionParticipantBannedEvent extends DiscussionEvent {
  final Participant participant;

  @override
  List<Object> get props => [this.participant];

  DiscussionParticipantBannedEvent({
    @required this.participant,
  }) : super();
}

class SubscribeToDiscussionEvent extends DiscussionEvent {
  final String discussionID;
  final bool isSubscribed;

  SubscribeToDiscussionEvent(this.discussionID, this.isSubscribed) : super();

  @override
  List<Object> get props => [this.discussionID, this.isSubscribed];
}

class UnsubscribeFromDiscussionEvent extends DiscussionEvent {
  final String discussionID;
  final bool hasUnsubscribed;

  UnsubscribeFromDiscussionEvent(this.discussionID, this.hasUnsubscribed)
      : super();

  @override
  List<Object> get props => [this.discussionID, this.hasUnsubscribed];
}

class LocalPostCreateSuccess extends DiscussionEvent {
  final Post createdPost;
  final LocalPost localPost;

  LocalPostCreateSuccess({@required this.createdPost, @required this.localPost})
      : super();

  @override
  List<Object> get props => [this.createdPost?.id, this.localPost?.key];
}

class LocalPostCreateFailure extends DiscussionEvent {
  final LocalPost localPost;
  final DateTime now;

  LocalPostCreateFailure({@required this.localPost})
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.localPost?.key, this.now];
}

class RefreshPostsEvent extends DiscussionEvent {
  final String discussionID;
  final DateTime now;

  RefreshPostsEvent({@required this.discussionID})
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.discussionID, this.now];
}

class LoadLocalDiscussionEvent extends DiscussionEvent {
  final Discussion discussion;

  LoadLocalDiscussionEvent({@required this.discussion});

  @override
  List<Object> get props => [this.discussion];
}

class LoadPreviousPostsPageEvent extends DiscussionEvent {
  final String discussionID;
  final DateTime now;

  LoadPreviousPostsPageEvent({@required this.discussionID})
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.discussionID, this.now];
}

class DiscussionShowOnboardingEvent extends DiscussionEvent {
  final String discussionID;

  DiscussionShowOnboardingEvent({
    @required this.discussionID,
  }) : super();

  @override
  List<Object> get props => [this.discussionID];
}

class DiscussionUpdateEvent extends DiscussionEvent {
  final String discussionID;
  final String title;
  final String selectedEmoji;
  final String description;

  DiscussionUpdateEvent({
    @required this.title,
    @required this.description,
    @required this.discussionID,
    @required this.selectedEmoji,
  }) : super();

  @override
  List<Object> get props => [this.title, this.discussionID, this.selectedEmoji];
}

class NextDiscussionOnboardingConciergeStep extends DiscussionEvent {
  final DateTime nonce;

  NextDiscussionOnboardingConciergeStep({
    @required this.nonce,
  }) : super();

  @override
  List<Object> get props => [this.nonce];
}

class DiscussionParticipantsMutedUnmutedEvent extends DiscussionEvent {
  final DateTime timestamp = DateTime.now();
  final List<Participant> participants;

  DiscussionParticipantsMutedUnmutedEvent({
    @required this.participants,
  });

  @override
  List<Object> get props => [this.participants, timestamp];
}

class DiscussionRespondToAccessRequestEvent extends DiscussionEvent {
  final DateTime timestamp = DateTime.now();
  final String requestID;
  final InviteRequestStatus status;

  DiscussionRespondToAccessRequestEvent({
    @required this.requestID,
    @required this.status,
  });

  @override
  List<Object> get props => [this.requestID, this.status, timestamp];
}

class _DiscussionRespondToAccessRequestAsyncEvent extends DiscussionEvent {
  final DateTime timestamp = DateTime.now();
  final DiscussionAccessRequest request;
  final error;

  _DiscussionRespondToAccessRequestAsyncEvent(this.request, this.error)
      : super();

  @override
  List<Object> get props => [this.timestamp, this.request, this.error];
}

class DiscussionMuteEvent extends DiscussionEvent {
  final String discussionID;
  final bool isMute;
  final DateTime timestamp;

  DiscussionMuteEvent({
    @required this.discussionID,
    @required this.isMute,
  }) : this.timestamp = DateTime.now();

  @override
  List<Object> get props => [this.discussionID, this.isMute, timestamp];
}

class RequestDiscussionAccessEvent extends DiscussionEvent {
  final String discussionID;
  final DateTime timestamp;

  RequestDiscussionAccessEvent({
    @required this.discussionID,
  }) : this.timestamp = DateTime.now();

  @override
  List<Object> get props => [this.discussionID, this.timestamp];
}

class DiscussionClearEvent extends DiscussionEvent {
  final DateTime now;

  DiscussionClearEvent()
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now];
}
