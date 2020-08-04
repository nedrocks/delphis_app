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

  DiscussionListArchiveEvent(this.discussion)
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now, this.discussion];
}

class _DiscussionListArchiveAsyncErrorEvent extends DiscussionListEvent {
  final DateTime now;
  final Discussion discussion;
  final error;

  _DiscussionListArchiveAsyncErrorEvent(this.discussion, this.error)
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now, this.discussion, this.error];
}

class _DiscussionListArchiveAsyncSuccessEvent extends DiscussionListEvent {
  final DateTime now;
  final Discussion discussion;

  _DiscussionListArchiveAsyncSuccessEvent(this.discussion)
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now, this.discussion];
}

class DiscussionListMuteEvent extends DiscussionListEvent {
  final DateTime now;
  final Discussion discussion;

  DiscussionListMuteEvent(this.discussion)
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now, this.discussion];
}

class _DiscussionListMuteAsyncErrorEvent extends DiscussionListEvent {
  final DateTime now;
  final Discussion discussion;
  final error;

  _DiscussionListMuteAsyncErrorEvent(this.discussion, this.error)
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now, this.discussion, this.error];
}

class DiscussionListUnMuteEvent extends DiscussionListEvent {
  final DateTime now;
  final Discussion discussion;

  DiscussionListUnMuteEvent(this.discussion)
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now, this.discussion];
}

class _DiscussionListUnMuteAsyncErrorEvent extends DiscussionListEvent {
  final DateTime now;
  final Discussion discussion;
  final error;

  _DiscussionListUnMuteAsyncErrorEvent(this.discussion, this.error)
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now, this.discussion, this.error];
}

class DiscussionListActivateEvent extends DiscussionListEvent {
  final DateTime now;
  final Discussion discussion;

  DiscussionListActivateEvent(this.discussion)
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now, this.discussion];
}

class _DiscussionListActivateAsyncErrorEvent extends DiscussionListEvent {
  final DateTime now;
  final Discussion discussion;
  final error;

  _DiscussionListActivateAsyncErrorEvent(this.discussion, this.error)
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now, this.discussion, this.error];
}

class _DiscussionListActivateAsyncSuccessEvent extends DiscussionListEvent {
  final DateTime now;
  final Discussion discussion;

  _DiscussionListActivateAsyncSuccessEvent(this.discussion)
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now, this.discussion];
}
