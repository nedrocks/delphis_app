part of 'discussion_viewer_bloc.dart';

abstract class DiscussionViewerEvent extends Equatable {
  const DiscussionViewerEvent();
}

class DiscussionViewerLoadedEvent extends DiscussionViewerEvent {
  final Viewer viewer;

  const DiscussionViewerLoadedEvent({
    @required this.viewer,
  });

  @override
  List<Object> get props =>
      [this.viewer?.id, this.viewer?.discussion?.id, this.viewer?.lastViewed];
}

class DiscussionViewerSetLastPostViewedEvent extends DiscussionViewerEvent {
  final Post post;

  const DiscussionViewerSetLastPostViewedEvent({
    @required this.post,
  });

  @override
  List<Object> get props => [
        this.post?.id,
      ];
}
