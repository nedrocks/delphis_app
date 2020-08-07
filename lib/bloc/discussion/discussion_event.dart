part of 'discussion_bloc.dart';

@immutable
abstract class DiscussionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/* Used to transform the local copy of discussion participants */
abstract class _DiscussionRefreshLocalParticipantsEvent
    extends DiscussionEvent {
  final Participant Function(Participant) mapping;
  final bool Function(Participant) filter;

  _DiscussionRefreshLocalParticipantsEvent({
    this.mapping,
    this.filter,
  }) : super() {
    assert(mapping != null || filter != null);
  }

  @override
  List<Object> get props => [this.mapping, this.filter];
}

/* Used to transform the local copy of discussion posts */
abstract class _DiscussionRefreshLocalPostsCacheEvent extends DiscussionEvent {
  final Post Function(Post) mapping;
  final bool Function(Post) filter;

  _DiscussionRefreshLocalPostsCacheEvent({
    this.mapping,
    this.filter,
  }) : super() {
    assert(mapping != null || filter != null);
  }

  @override
  List<Object> get props => [this.mapping, this.filter];
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

class DiscussionConciergeOptionSelectedEvent extends DiscussionEvent {
  final String discussionID;
  final String mutationID;
  final List<String> selectedOptionIDs;

  DiscussionConciergeOptionSelectedEvent({
    @required this.discussionID,
    @required this.mutationID,
    @required this.selectedOptionIDs,
  }) : super();

  @override
  List<Object> get props =>
      [this.discussionID, this.mutationID, this.selectedOptionIDs];
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

class DiscussionMuteUnmuteParticipantsRefreshEvent
    extends _DiscussionRefreshLocalParticipantsEvent {
  final DateTime nonce = DateTime.now();
  final List<Participant> participants;

  DiscussionMuteUnmuteParticipantsRefreshEvent(this.participants)
      : super(
          mapping: (p) {
            for (var participant in participants) {
              if (p.id == participant.id) {
                return participant;
              }
            }
            return p;
          },
        );

  List<Object> get props => [this.nonce, participants];
}

class DiscussionDeleteParticipantRefreshEvent
    extends _DiscussionRefreshLocalParticipantsEvent {
  final DateTime nonce = DateTime.now();
  final Participant participant;

  DiscussionDeleteParticipantRefreshEvent(this.participant)
      : super(filter: (p) => p.id != participant.id);

  List<Object> get props => [this.nonce, participant];
}

class DiscussionDeleteParticipantPostsRefreshEvent
    extends _DiscussionRefreshLocalPostsCacheEvent {
  final DateTime nonce = DateTime.now();
  final Participant participant;

  DiscussionDeleteParticipantPostsRefreshEvent(this.participant)
      : super(
          mapping: (Post post) {
            if (post.participant.id == participant.id)
              return post.copyWith(
                  isDeleted: true,
                  deletedReasonCode: PostDeletedReason.MODERATOR_REMOVED);
            return post;
          },
        );

  List<Object> get props => [this.nonce, participant];
}

class DiscussionDeletePostRefreshEvent
    extends _DiscussionRefreshLocalPostsCacheEvent {
  final DateTime nonce = DateTime.now();
  final Post post;

  DiscussionDeletePostRefreshEvent(this.post)
      : super(filter: (p) => p.id != post.id);

  List<Object> get props => [this.nonce, post];
}
