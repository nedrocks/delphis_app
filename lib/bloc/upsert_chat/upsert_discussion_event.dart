part of 'upsert_discussion_bloc.dart';

abstract class UpsertDiscussionEvent extends Equatable {
  const UpsertDiscussionEvent();
}

/* Whenever the authed user changes */
class UpsertDiscussionMeUserChangeEvent extends UpsertDiscussionEvent {
  final DateTime timestamp = DateTime.now();
  final User me;

  UpsertDiscussionMeUserChangeEvent(this.me);

  @override
  List<Object> get props => [timestamp, me];
}

/* Whenever a discussion gets selected to be edited/updated */
class UpsertDiscussionSelectDiscussionEvent extends UpsertDiscussionEvent {
  final DateTime timestamp = DateTime.now();
  final Discussion discussion;

  UpsertDiscussionSelectDiscussionEvent(this.discussion);

  @override
  List<Object> get props => [timestamp, discussion];
}

/* Whenever a the user wants to finalize a new discussion creation
   with the current BLoC state configuration */
class UpsertDiscussionCreateDiscussionEvent extends UpsertDiscussionEvent {
  final DateTime timestamp = DateTime.now();

  UpsertDiscussionCreateDiscussionEvent();

  @override
  List<Object> get props => [timestamp];
}

/* Whenever a the user wants to finalize a new discussion creation
   with the current BLoC state configuration */
class UpsertDiscussionUpdateDiscussionEvent extends UpsertDiscussionEvent {
  final DateTime timestamp = DateTime.now();

  UpsertDiscussionUpdateDiscussionEvent();

  @override
  List<Object> get props => [timestamp];
}

/* Whenever a user wants to set some data fields of the fields in the current
   editing/creation state. */
class UpsertDiscussionSetTitleDescriptionEvent extends UpsertDiscussionEvent {
  final DateTime timestamp = DateTime.now();
  final String title;
  final String description;

  UpsertDiscussionSetTitleDescriptionEvent({this.title, this.description});

  @override
  List<Object> get props => [timestamp, title, description];
}

/* Whenever a user wants to set some data fields of the fields in the current
   editing/creation state. */
class UpsertDiscussionSetInviteModeEvent extends UpsertDiscussionEvent {
  final DateTime timestamp = DateTime.now();
  final DiscussionJoinabilitySetting inviteMode;

  UpsertDiscussionSetInviteModeEvent({this.inviteMode});

  @override
  List<Object> get props => [timestamp, inviteMode];
}
