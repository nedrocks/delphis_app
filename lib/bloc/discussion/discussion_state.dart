part of 'discussion_bloc.dart';

@immutable
abstract class DiscussionState extends Equatable {
  Discussion getDiscussion();

  @override
  List<Object> get props => [getDiscussion()];
}

class DiscussionUninitializedState extends DiscussionState {
  @override
  Discussion getDiscussion() {
    return null;
  }
}

class DiscussionLoadingState extends DiscussionState {
  @override
  Discussion getDiscussion() {
    return null;
  }
}

class DiscussionErrorState extends DiscussionState {
  final Exception error;

  DiscussionErrorState(this.error) : super();

  @override
  Discussion getDiscussion() {
    return null;
  }
}

class DiscussionLoadedState extends DiscussionState {
  final Discussion discussion;
  final DateTime lastUpdate;
  final Stream<Post> discussionPostStream;
  final Map<GlobalKey, LocalPost> localPosts;

  DiscussionLoadedState({
    @required this.discussion,
    @required this.lastUpdate,
    this.discussionPostStream,
    localPosts,
  })  : this.localPosts = localPosts ?? Map<GlobalKey, LocalPost>(),
        super();

  Discussion getDiscussion() {
    return this.discussion;
  }

  DiscussionLoadedState update({
    Stream<Post> stream,
    Discussion discussion,
    Map<GlobalKey, LocalPost> localPosts,
  }) {
    return DiscussionLoadedState(
      discussion: discussion ?? this.discussion,
      lastUpdate: DateTime.now(),
      discussionPostStream: stream ?? this.discussionPostStream,
      localPosts: localPosts ?? this.localPosts,
    );
  }

  @override
  List<Object> get props => [this.discussion, this.lastUpdate];
}

// enum PostAddStep {
//   INITIATED,
//   SUCCESS,
//   ERROR,
// }

// class DiscussionAddPostState extends DiscussionLoadedState {
//   final PostAddStep step;
//   final String postContent;

//   DiscussionAddPostState(
//       {@required discussion,
//       @required this.step,
//       @required this.postContent,
//       @required lastUpdate,
//       discussionPostStream})
//       : super(
//             discussion: discussion,
//             lastUpdate: lastUpdate,
//             discussionPostStream: discussionPostStream);

//   @override
//   List<Object> get props => super.props + [this.postContent, this.step];

//   @override
//   DiscussionAddPostState update({Stream<Post> stream, Discussion discussion}) {
//     return DiscussionAddPostState(
//       discussion: discussion ?? this.discussion,
//       step: this.step,
//       postContent: this.postContent,
//       lastUpdate: DateTime.now(),
//       discussionPostStream: stream ?? this.discussionPostStream,
//     );
//   }
// }
