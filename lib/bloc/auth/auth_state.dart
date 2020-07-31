part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class LoggedOutAuthState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoadingAuthState extends AuthState {
  final DateTime timestamp = DateTime.now();
  @override
  List<Object> get props => [timestamp];
}

class ErrorAuthState extends AuthState {
  final DateTime timestamp = DateTime.now();
  final error;

  ErrorAuthState(this.error);

  @override
  List<Object> get props => [error, timestamp];
}

class SignedInAuthState extends AuthState {
  final DateTime timestamp = DateTime.now();
  final String authString;
  final bool isLocal;

  SignedInAuthState(this.authString, this.isLocal) : super();

  @override
  List<Object> get props => [this.authString, this.isLocal, this.timestamp];
}
