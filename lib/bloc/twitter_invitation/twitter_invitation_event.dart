part of 'twitter_invitation_bloc.dart';

abstract class TwitterInvitationEvent extends Equatable {
  const TwitterInvitationEvent();
}

class TwitterInvitationResetEvent extends TwitterInvitationEvent {
  const TwitterInvitationResetEvent();

  @override
  List<Object> get props => throw UnimplementedError();
}

class TwitterInvitationInviteEvent extends TwitterInvitationEvent {
  final DateTime now;
  final String discussionID;
  final String invitingParticipantID;
  final List<TwitterUserInput> invitedTwitterUsers;

  TwitterInvitationInviteEvent(
      {now,
      this.discussionID,
      this.invitingParticipantID,
      this.invitedTwitterUsers})
      : this.now = now ?? DateTime.now(),
        super();

  @override
  List<Object> get props => [
        this.now,
        this.discussionID,
        this.invitingParticipantID,
        this.invitedTwitterUsers
      ];
}

class TwitterInvitationSearchEvent extends TwitterInvitationEvent {
  final DateTime now;
  final String query;
  final String discussionID;
  final String invitingParticipantID;

  TwitterInvitationSearchEvent(
      {now, this.query, this.discussionID, this.invitingParticipantID})
      : this.now = now ?? DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now, this.query];
}
