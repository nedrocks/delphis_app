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
  final List<Discussion> visibleDiscussionList;
  final bool isLoading;

  const DiscussionListLoaded({
    @required this.discussionList,
    @required this.isLoading,
    @required this.visibleDiscussionList, 
  }) : super();

  @override
  List<Object> get props => [this.discussionList, this.isLoading];
}
