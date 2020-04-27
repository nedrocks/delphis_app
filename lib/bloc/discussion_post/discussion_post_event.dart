part of 'discussion_post_bloc.dart';

abstract class DiscussionPostEvent extends Equatable {
  const DiscussionPostEvent();
}

class DiscussionPostsLoadedEvent extends DiscussionPostEvent {
  final List<Post> posts;

  const DiscussionPostsLoadedEvent(this.posts) : super();

  @override
  List<Object> get props => [this.posts];
}

class DiscussionPostAddEvent extends DiscussionPostEvent {
  final String postContent;

  @override
  List<Object> get props => [this.postContent];

  DiscussionPostAddEvent({
    @required this.postContent,
  }) : super();
}

class DiscussionPostAddedEvent extends DiscussionPostEvent {
  final Post addedPost;

  @override
  List<Object> get props => [this.addedPost];

  DiscussionPostAddedEvent(
    @required this.addedPost,
  ) : super();
}

class SubscribeToDiscussionEvent extends DiscussionPostEvent {
  final String discussionID;
  final bool isSubscribed;

  SubscribeToDiscussionEvent(this.discussionID, this.isSubscribed) : super();

  @override
  List<Object> get props => [this.discussionID, this.isSubscribed];
}

class UnsubscribeFromDiscussionEvent extends DiscussionPostEvent {
  final String discussionID;
  final bool hasUnsubscribed;

  UnsubscribeFromDiscussionEvent(this.discussionID, this.hasUnsubscribed)
      : super();

  @override
  List<Object> get props => [this.discussionID, this.hasUnsubscribed];
}
