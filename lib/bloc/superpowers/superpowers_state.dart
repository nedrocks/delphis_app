part of 'superpowers_bloc.dart';

abstract class SuperpowersState extends Equatable {
  const SuperpowersState();
}


class ReadyState extends SuperpowersState {
  const ReadyState();
  @override
  List<Object> get props => [];
}

abstract class SuccessState extends ReadyState {
  final String message;

  const SuccessState({
    @required this.message
  });

  @override
  List<Object> get props => [this.message];
}

class LoadingState extends SuperpowersState {
  @override
  List<Object> get props => [];
}

class ErrorState extends ReadyState {
  final String message;

  const ErrorState({
    @required this.message
  });

  @override
  List<Object> get props => [this.message];
}

class DeletePostSuccessState extends SuccessState {
  final Post post;

  const DeletePostSuccessState({
    @required message,
    @required this.post
  }) : super(message: message);

  @override
  List<Object> get props => [this.message, this.post];
}

class BanParticipantSuccessState extends SuccessState {
  final Participant participant;

  const BanParticipantSuccessState({
    @required message,
    @required this.participant
  }) : super(message: message);

  @override
  List<Object> get props => [this.message, this.participant];
}