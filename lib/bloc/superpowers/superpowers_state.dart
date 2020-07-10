part of 'superpowers_bloc.dart';

abstract class SuperpowersState extends Equatable {
  final DateTime timestamp;
  
  SuperpowersState(this.timestamp);
  
  List<Object> get props => [this.timestamp];
}

class ReadyState extends SuperpowersState {
  ReadyState() : super(DateTime.now());

  @override
  List<Object> get props => [this.timestamp];
}

abstract class SuccessState extends ReadyState {
  final String message;

  SuccessState({
    @required this.message
  });

  @override
  List<Object> get props => [this.timestamp, this.message];
}

class LoadingState extends SuperpowersState {
  LoadingState() : super(DateTime.now());

  @override
  List<Object> get props => [this.timestamp];
}

class ErrorState extends ReadyState {
  final String message;

  ErrorState({
    @required this.message
  });

  @override
  List<Object> get props => [this.timestamp, this.message];
}

class DeletePostSuccessState extends SuccessState {
  final Post post;

  DeletePostSuccessState({
    @required message,
    @required this.post
  }) : super(message: message);

  @override
  List<Object> get props => [this.timestamp, this.message, this.post];
}

class BanParticipantSuccessState extends SuccessState {
  final Participant participant;

  BanParticipantSuccessState({
    @required message,
    @required this.participant
  }) : super(message: message);

  @override
  List<Object> get props => [this.timestamp, this.message, this.participant];
}