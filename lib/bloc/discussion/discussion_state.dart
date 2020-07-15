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
  final Stream<DiscussionSubscriptionEvent> discussionPostStream;
  final Map<GlobalKey, LocalPost> localPosts;

  final bool isLoading;

  final int onboardingConciergeStep;

  DiscussionLoadedState({
    @required this.discussion,
    @required this.lastUpdate,
    this.isLoading = false,
    this.discussionPostStream,
    this.onboardingConciergeStep,
    localPosts,
  })  : this.localPosts = localPosts ?? Map<GlobalKey, LocalPost>(),
        super();

  Discussion getDiscussion() {
    return this.discussion;
  }

  DiscussionLoadedState update({
    Stream<DiscussionSubscriptionEvent> stream,
    Discussion discussion,
    Map<GlobalKey, LocalPost> localPosts,
    bool isLoading,
    int onboardingConciergeStep,
  }) {
    return DiscussionLoadedState(
        discussion: discussion ?? this.discussion,
        lastUpdate: DateTime.now(),
        discussionPostStream: stream ?? this.discussionPostStream,
        localPosts: localPosts ?? this.localPosts,
        isLoading: isLoading ?? this.isLoading,
        onboardingConciergeStep:
            onboardingConciergeStep ?? this.onboardingConciergeStep);
  }

  @override
  List<Object> get props => [this.discussion, this.lastUpdate, this.isLoading];
}

class AddingDiscussionState extends DiscussionState {
  final String title;
  final AnonymityType anonymityType;

  AddingDiscussionState({@required this.title, @required this.anonymityType})
      : super();

  Discussion getDiscussion() {
    return null;
  }

  @override
  List<Object> get props => [this.title, this.anonymityType];
}
