part of 'discussion_list_bloc.dart';

abstract class DiscussionListState extends Equatable {
  const DiscussionListState();
}

class DiscussionListInitial extends DiscussionListState {
  @override
  List<Object> get props => [];
}

class DiscussionListLoaded extends DiscussionListState {
  final List<Discussion> discussionList;
  final bool isLoading;

  const DiscussionListLoaded({
    @required this.discussionList,
    @required this.isLoading,
  }) : super();

  @override
  List<Object> get props => [this.discussionList, this.isLoading];
}
