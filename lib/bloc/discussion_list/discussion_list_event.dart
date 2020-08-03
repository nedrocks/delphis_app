part of 'discussion_list_bloc.dart';

abstract class DiscussionListEvent extends Equatable {
  const DiscussionListEvent();
}

class DiscussionListFetchEvent extends DiscussionListEvent {
  final DateTime now;

  DiscussionListFetchEvent()
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now];
}

class DiscussionListDeleteEvent extends DiscussionListEvent {
  final DateTime now;
  final Discussion discussion;

  DiscussionListDeleteEvent(this.discussion)
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now, this.discussion];
}

class DiscussionListArchiveEvent extends DiscussionListEvent {
  final DateTime now;
  final Discussion discussion;
  final bool archived;

  DiscussionListArchiveEvent(this.discussion, this.archived)
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now, this.discussion, this.archived];
}

class DiscussionListMuteEvent extends DiscussionListEvent {
  final DateTime now;
  final Discussion discussion;
  final bool muted;

  DiscussionListMuteEvent(this.discussion, this.muted)
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now, this.discussion, this.muted];
}
