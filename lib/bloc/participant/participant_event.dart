part of 'participant_bloc.dart';

abstract class ParticipantEvent extends Equatable {
  const ParticipantEvent();
}

class ParticipantEventReceivedParticipant extends ParticipantEvent {
  final Participant participant;

  const ParticipantEventReceivedParticipant({
    @required this.participant,
  }) : super();

  @override
  List<Object> get props => [this.participant];
}

class ParticipantEventUpdateParticipant extends ParticipantEvent {
  // This is to ensure we have inequality if we use the same set of updates
  // for two separate participants.
  final String participantID;
  final GradientName gradientName;
  final Flair flair;
  final bool isAnonymous;
  final bool isUnsetFlairID;
  final bool isUnsetGradient;

  const ParticipantEventUpdateParticipant({
    @required this.participantID,
    this.gradientName,
    this.flair,
    this.isAnonymous,
    this.isUnsetFlairID,
    this.isUnsetGradient,
  }) : super();

  @override
  List<Object> get props => [
        this.participantID,
        this.gradientName,
        this.flair,
        this.isAnonymous,
        this.isUnsetFlairID,
        this.isUnsetGradient
      ];
}
