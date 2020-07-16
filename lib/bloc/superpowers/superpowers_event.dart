part of 'superpowers_bloc.dart';

abstract class SuperpowersEvent extends Equatable {
  const SuperpowersEvent();
}

class ResetEvent extends SuperpowersEvent {
  @override
  List<Object> get props => [];
}

class DeletePostEvent extends SuperpowersEvent {
  final Discussion discussion;
  final Post post;

  const DeletePostEvent({
    @required this.discussion,
    @required this.post
  });

  @override
  List<Object> get props => [discussion, post];
}

class BanParticipantEvent extends SuperpowersEvent {
  final Discussion discussion;
  final Participant participant;

  const BanParticipantEvent({
    @required this.discussion,
    @required this.participant
  });

  @override
  List<Object> get props => [discussion, participant];
}

class CopyDiscussionLinkEvent extends SuperpowersEvent {
  final Discussion discussion;
  final bool isVip;

  const CopyDiscussionLinkEvent({
    @required this.discussion,
    @required this.isVip
  });

  @override
  List<Object> get props => [discussion, isVip];
}

class InviteTwitterUserEvent extends SuperpowersEvent {
  final String twitterHandle;

  const InviteTwitterUserEvent({
    @required this.twitterHandle
  });

  @override
  List<Object> get props => [twitterHandle];
}