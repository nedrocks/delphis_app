part of 'moderator_bloc.dart';

abstract class ModeratorEvent extends Equatable {
  const ModeratorEvent();
}

class CloseEvent extends ModeratorEvent {
  @override
  List<Object> get props => [];
}

class DeletePostEvent extends ModeratorEvent {
  final Discussion discussion;
  final Post post;

  const DeletePostEvent({
    @required this.discussion,
    @required this.post
  });

  @override
  List<Object> get props => [discussion, post];
}

class BanParticipantEvent extends ModeratorEvent {
  final Discussion discussion;
  final Participant participant;

  const BanParticipantEvent({
    @required this.discussion,
    @required this.participant
  });

  @override
  List<Object> get props => [discussion, participant];
}