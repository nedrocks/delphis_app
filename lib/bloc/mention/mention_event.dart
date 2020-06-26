part of 'mention_bloc.dart';

abstract class MentionEvent extends Equatable {
  const MentionEvent();
}

class AddMentionDataEvent extends MentionEvent {
  final Discussion discussion;
  final List<Discussion> discussions;
  final List<Discussion> visibleDiscussions;

  AddMentionDataEvent({this.discussion, this.discussions, this.visibleDiscussions});

  @override
  List<Object> get props => [discussion, discussions, visibleDiscussions];
}
