part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class InitialAuthState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoadingAuthState extends AuthState {
  @override
  List<Object> get props => [];
}

class InitializedAuthState extends AuthState {
  final String authString;
  final bool isAuthed;

  const InitializedAuthState(this.authString, this.isAuthed) : super();

  @override
  List<Object> get props => [this.authString, this.isAuthed];
}

class LoggedOutAuthState extends AuthState {
  @override
  List<Object> get props => [];
}
