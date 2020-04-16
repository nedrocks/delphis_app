part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class FetchAuthEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class LoadedAuthEvent extends AuthEvent {
  final String authString;
  final bool isSuccess;
  final bool isFromLocalStorage;

  const LoadedAuthEvent(this.authString, this.isSuccess, this.isFromLocalStorage): super();

  @override
  List<Object> get props => [this.authString, this.isSuccess];
}