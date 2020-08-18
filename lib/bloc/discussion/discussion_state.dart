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
  final error;

  DiscussionErrorState(this.error) : super();

  @override
  Discussion getDiscussion() {
    return null;
  }
}

class DiscussionLoadedState extends DiscussionState {
  final Discussion discussion;
  final DateTime lastUpdate;
  final Stream<DiscussionSubscriptionEvent> discussionPostStream;
  final StreamSubscription<DiscussionSubscriptionEvent> discussionPostListener;
  final Map<GlobalKey, LocalPost> localPosts;

  final bool isLoading;

  final int onboardingConciergeStep;

  DiscussionLoadedState({
    @required this.discussion,
    @required this.lastUpdate,
    this.isLoading = false,
    this.discussionPostStream,
    this.discussionPostListener,
    this.onboardingConciergeStep,
    localPosts,
  })  : this.localPosts = localPosts ?? Map<GlobalKey, LocalPost>(),
        super();

  Discussion getDiscussion() {
    return this.discussion;
  }

  DiscussionLoadedState update({
    Stream<DiscussionSubscriptionEvent> stream,
    StreamSubscription<DiscussionSubscriptionEvent> listener,
    Discussion discussion,
    Map<GlobalKey, LocalPost> localPosts,
    bool isLoading,
    int onboardingConciergeStep,
  }) {
    return DiscussionLoadedState(
        discussion: discussion ?? this.discussion,
        lastUpdate: DateTime.now(),
        discussionPostStream: stream ?? this.discussionPostStream,
        discussionPostListener: listener ?? this.discussionPostListener,
        localPosts: localPosts ?? this.localPosts,
        isLoading: isLoading ?? this.isLoading,
        onboardingConciergeStep:
            onboardingConciergeStep ?? this.onboardingConciergeStep);
  }

  @override
  List<Object> get props => [this.discussion, this.lastUpdate, this.isLoading];
}
