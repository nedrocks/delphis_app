part of 'discussion_viewer_bloc.dart';

abstract class DiscussionViewerState extends Equatable {
  const DiscussionViewerState();
}

class DiscussionViewerUnInitialized extends DiscussionViewerState {
  @override
  List<Object> get props => [];
}

class DiscussionViewerInitialized extends DiscussionViewerState {
  final Viewer viewer;
  final DateTime lastUpdateSent;
  final Post pendingUpdate;
  final bool isUpdating;

  const DiscussionViewerInitialized({
    @required this.viewer,
    @required this.lastUpdateSent,
    @required this.pendingUpdate,
    @required this.isUpdating,
  });

  @override
  List<Object> get props => [
        this.viewer?.discussion?.id,
        this.viewer?.id,
        this.viewer?.lastViewed,
        this.lastUpdateSent,
        this.isUpdating,
      ];

  DiscussionViewerInitialized copyWith({
    Viewer viewer,
    DateTime lastUpdateSent,
    // Required because may be null
    @required Post pendingUpdate,
    bool isUpdating,
  }) {
    return DiscussionViewerInitialized(
      viewer: viewer ?? this.viewer,
      lastUpdateSent: lastUpdateSent ?? this.lastUpdateSent,
      pendingUpdate: pendingUpdate,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}
