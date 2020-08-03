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

class _DiscussionListDeleteAsyncErrorEvent extends DiscussionListEvent {
  final DateTime now;
  final Discussion discussion;
  final error;

  _DiscussionListDeleteAsyncErrorEvent(this.discussion, this.error)
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now, this.discussion, this.error];
}

class _DiscussionListDeleteAsyncSuccessEvent extends DiscussionListEvent {
  final DateTime now;
  final Discussion discussion;

  _DiscussionListDeleteAsyncSuccessEvent(this.discussion)
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

class _DiscussionListArchiveAsyncErrorEvent extends DiscussionListEvent {
  final DateTime now;
  final Discussion discussion;
  final bool wasArchived;
  final error;

  _DiscussionListArchiveAsyncErrorEvent(
      this.discussion, this.wasArchived, this.error)
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props =>
      [this.now, this.discussion, this.wasArchived, this.error];
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

class _DiscussionListMuteAsyncErrorEvent extends DiscussionListEvent {
  final DateTime now;
  final Discussion discussion;
  final bool wasMuted;
  final error;

  _DiscussionListMuteAsyncErrorEvent(this.discussion, this.wasMuted, this.error)
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props =>
      [this.now, this.discussion, this.wasMuted, this.error];
}
