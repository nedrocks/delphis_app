part of 'discussion_list_bloc.dart';

abstract class DiscussionListState extends Equatable {
  final List<Discussion> discussionList = [];
  DiscussionListState();
}

abstract class DiscussionListHasTimestamp extends DiscussionListState {
  DateTime get timestamp;
}

class DiscussionListInitial extends DiscussionListState {
  @override
  List<Object> get props => [];
}

class DiscussionListError extends DiscussionListHasTimestamp {
  final List<Discussion> discussionList;
  final error;
  final DateTime timestamp;

  DiscussionListError({
    @required this.discussionList,
    @required this.error,
    @required this.timestamp,
  }) : super();

  @override
  List<Object> get props => [this.discussionList, this.error, this.timestamp];
}

class DiscussionListLoading extends DiscussionListHasTimestamp {
  final List<Discussion> discussionList;
  final DateTime timestamp;

  DiscussionListLoading({
     @required this.discussionList,
    @required this.timestamp,
  }) : super();

  @override
  List<Object> get props => [this.discussionList, this.timestamp];
}

class DiscussionListLoaded extends DiscussionListHasTimestamp {
  final List<Discussion> discussionList;
  final DateTime timestamp;

  DiscussionListLoaded({
    @required this.discussionList,
    @required this.timestamp,
  }) : super();

  @override
  List<Object> get props => [this.discussionList, this.timestamp];
}
