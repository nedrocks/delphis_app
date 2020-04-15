part of 'discussion_post_bloc.dart';

const emptyList = <Post>[];

abstract class DiscussionPostState extends Equatable {
  final List<Post> posts;

  const DiscussionPostState({
    @required this.posts,
  });

  @override
  List<Object> get props => [this.posts];
}

class DiscussionPostInitialState extends DiscussionPostState {
  const DiscussionPostInitialState(): super(posts: emptyList);
}

enum PostAddStep {
  INITIATED,
  SUCCESS,
  ERROR,
}

class DiscussionPostAddState extends DiscussionPostState {
  final PostAddStep step;
  final String postContent;

  const DiscussionPostAddState({
    @required this.postContent,
    @required this.step,
    @required posts,
  }): super(posts: posts);

  @override
  List<Object> get props => [this.posts, this.step, this.postContent];
}

class DiscussionPostLoadedState extends DiscussionPostState {
  const DiscussionPostLoadedState({
    @required posts,
  }): super(posts: posts);
}
