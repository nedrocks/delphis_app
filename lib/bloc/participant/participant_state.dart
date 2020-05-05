part of 'participant_bloc.dart';

abstract class ParticipantState extends Equatable {
  final Participant participant;

  const ParticipantState({
    @required this.participant,
  });

  @override
  List<Object> get props => [this.participant];
}

class ParticipantInitial extends ParticipantState {
  const ParticipantInitial() : super(participant: null);

  @override
  List<Object> get props => super.props;
}

class ParticipantLoaded extends ParticipantState {
  final bool isUpdating;

  const ParticipantLoaded({
    @required participant,
    this.isUpdating,
  }) : super(participant: participant);

  @override
  List<Object> get props => super.props + [this.isUpdating];
}
