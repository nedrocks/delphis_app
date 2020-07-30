part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class TwitterSignInAuthEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AppleSignInAuthEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class LocalSignInAuthEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class LogoutAuthEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class SetTokenAuthEvent extends AuthEvent {
  final String token;

  SetTokenAuthEvent(this.token);

  @override
  List<Object> get props => [token];
}
