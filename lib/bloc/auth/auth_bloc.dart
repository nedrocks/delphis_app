import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/data/repository/auth.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final DelphisAuthRepository repository;

  AuthBloc(this.repository) : super(InitialAuthState());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    final currentState = this.state;
    if (event is FetchAuthEvent &&
        (currentState is InitialAuthState ||
            currentState is InitializedAuthState)) {
      yield LoadingAuthState();
      final isAuthed = await this.repository.loadFromStorage();
      yield InitializedAuthState(this.repository.authString, isAuthed);
    } else if (event is LoadedAuthEvent) {
      if (event.isSuccess) {
        this.repository.authString = event.authString;
      }
      yield InitializedAuthState(event.authString, event.isSuccess);
    } else if (event is LogoutAuthEvent) {
      await this.repository.logout();
      // We yield this to ensure the app shows the logged out views.
      yield LoggedOutAuthState();
      yield InitializedAuthState(null, false);
    }
  }
}
