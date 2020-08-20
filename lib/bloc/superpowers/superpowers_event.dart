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

  const DeletePostEvent({@required this.discussion, @required this.post});

  @override
  List<Object> get props => [discussion, post];
}

class SetShuffleTimeEvent extends SuperpowersEvent {
  final Discussion discussion;
  final int shuffleInSeconds;

  const SetShuffleTimeEvent({
    @required this.discussion,
    @required this.shuffleInSeconds,
  });

  @override
  List<Object> get props => [discussion?.id, shuffleInSeconds];
}

class ChangeLockStatusEvent extends SuperpowersEvent {
  final Discussion discussion;
  final bool isLock;

  const ChangeLockStatusEvent({
    @required this.discussion,
    @required this.isLock,
  });

  @override
  List<Object> get props => [discussion?.id, isLock];
}

class BanParticipantEvent extends SuperpowersEvent {
  final Discussion discussion;
  final Participant participant;

  const BanParticipantEvent(
      {@required this.discussion, @required this.participant});

  @override
  List<Object> get props => [discussion, participant];
}

class MuteParticipantEvent extends SuperpowersEvent {
  final Discussion discussion;
  final List<Participant> participants;
  final int muteForSeconds;

  const MuteParticipantEvent({
    @required this.discussion,
    @required this.participants,
    @required this.muteForSeconds,
  });

  @override
  List<Object> get props => [discussion, participants];
}

class UnmuteParticipantEvent extends SuperpowersEvent {
  final Discussion discussion;
  final List<Participant> participants;

  const UnmuteParticipantEvent({
    @required this.discussion,
    @required this.participants,
  });

  @override
  List<Object> get props => [discussion, participants];
}

class CopyDiscussionLinkEvent extends SuperpowersEvent {
  final Discussion discussion;
  final bool isVip;

  const CopyDiscussionLinkEvent(
      {@required this.discussion, @required this.isVip});

  @override
  List<Object> get props => [discussion, isVip];
}
