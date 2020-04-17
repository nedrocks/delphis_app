import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/data/repository/auth.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final DelphisAuthRepository repository;

  AuthBloc(this.repository);

  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    final currentState = this.state;
    if (event is FetchAuthEvent && (currentState is InitialAuthState || currentState is InitializedAuthState)) {
      yield LoadingAuthState();
      final isAuthed = await this.repository.loadFromStorage();
      yield InitializedAuthState(this.repository.authString, isAuthed);
    }
    if (event is LoadedAuthEvent) {
      yield InitializedAuthState(event.authString, event.isSuccess);
    }
  }
}
