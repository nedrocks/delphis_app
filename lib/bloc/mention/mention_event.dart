part of 'mention_bloc.dart';

abstract class MentionEvent extends Equatable {
  const MentionEvent();
}

class AddMentionDataEvent extends MentionEvent {
  final Discussion discussion;
  final List<Discussion> discussions;

  AddMentionDataEvent({this.discussion, this.discussions});

  @override
  List<Object> get props => [discussion, discussions];
}
