part of 'moderator_bloc.dart';

abstract class ModeratorEvent extends Equatable {
  const ModeratorEvent();
}

class CloseEvent extends ModeratorEvent {
  @override
  List<Object> get props => [];
}

class DeletePostEvent extends ModeratorEvent {
  final Post post;

  const DeletePostEvent({
    @required this.post
  });

  @override
  List<Object> get props => [post];
}

class KickParticipantEvent extends ModeratorEvent {
  final Participant participant;

  const KickParticipantEvent({
    @required this.participant
  });

  @override
  List<Object> get props => [participant];
}