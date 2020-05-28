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
