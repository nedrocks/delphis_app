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
  final VoidCallback onSuccess;
  final Function(dynamic) onError;
  
  const ParticipantEventUpdateParticipant({
    @required this.participantID,
    this.gradientName,
    this.flair,
    this.isAnonymous,
    this.isUnsetFlairID,
    this.isUnsetGradient,
    this.onSuccess,
    this.onError
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

class ParticipantEventAddParticipant extends ParticipantEvent {
  final String discussionID;
  final String userID;
  final GradientName gradientName;
  final String flairID;
  final bool isAnonymous;
  final bool hasJoined;

  const ParticipantEventAddParticipant({
    @required this.discussionID,
    @required this.userID,
    @required this.isAnonymous,
    this.gradientName,
    this.flairID,
    this.hasJoined = false,
  }) : super();

  // Only these two matter.
  @override
  List<Object> get props => [
        this.discussionID,
        this.userID,
      ];
}

class ParticipantJoinedDiscussion extends ParticipantEvent {
  final Participant participant;

  ParticipantJoinedDiscussion({@required this.participant}) : super();

  @override
  List<Object> get props => [this.participant.id];
}
