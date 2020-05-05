part of 'discussion_bloc.dart';

@immutable
abstract class DiscussionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DiscussionQueryEvent extends DiscussionEvent {
  final String discussionId;

  DiscussionQueryEvent(this.discussionId) : super();

  @override
  List<Object> get props => [this.discussionId];
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

  DiscussionPostsUpdatedEvent(this.posts) : super();

  @override
  List<Object> get props => [this.posts];
}

class ParticipantSettingsUpdateEvent extends DiscussionEvent {
  // Any of these may be null.
  final bool isAnonymous;
  final GradientName gradientName;
  final Flair flair;

  ParticipantSettingsUpdateEvent({
    this.isAnonymous,
    this.gradientName,
    this.flair,
  }) : super();
}
