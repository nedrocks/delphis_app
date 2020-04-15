part of 'discussion_post_bloc.dart';

abstract class DiscussionPostEvent extends Equatable {
  const DiscussionPostEvent();
}

class DiscussionPostsLoadedEvent extends DiscussionPostEvent {
  final List<Post> posts;

  const DiscussionPostsLoadedEvent(this.posts): super();

  @override
  List<Object> get props => [this.posts];
}

class DiscussionPostAddEvent extends DiscussionPostEvent {
  final String postContent;

  @override
  List<Object> get props => [this.postContent];

  DiscussionPostAddEvent({
    @required this.postContent,
  }): super();
}