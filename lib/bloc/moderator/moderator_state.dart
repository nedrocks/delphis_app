part of 'moderator_bloc.dart';

abstract class ModeratorState extends Equatable {
  const ModeratorState();
}


class ReadyState extends ModeratorState {
  const ReadyState();
  @override
  List<Object> get props => [];
}

class LoadingState extends ModeratorState {
  @override
  List<Object> get props => [];
}

class ErrorState extends ReadyState {
  final String message;

  ErrorState({
    @required this.message
  });

  @override
  List<Object> get props => [this.message];
}

class SuccessState extends ReadyState {
  final String message;

  SuccessState({
    @required this.message
  });

  @override
  List<Object> get props => [this.message];
}