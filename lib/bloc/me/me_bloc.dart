import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/bloc/auth/auth_bloc.dart';
import 'package:delphis_app/bloc/gql_client/gql_client_bloc.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_segment/flutter_segment.dart';

part 'me_event.dart';
part 'me_state.dart';

class MeBloc extends Bloc<MeEvent, MeState> {
  final UserRepository repository;
  final AuthBloc authBloc;
  final GqlClientBloc gqlBloc;

  MeBloc(this.repository, this.authBloc, this.gqlBloc) : super(MeInitial()) {
    this.authBloc.listen((AuthState state) {
      if (state is LoggedOutAuthState) {
        this.add(LogoutMeEvent());
      }
    });
    this.gqlBloc.listen((GqlClientState state) {
      if (state is GqlClientConnectedState && this.state is LoadedMeState) {
        final me = extractMe(this.state);
        if (me != null && !me.isTwitterAuth) {
          this.add(FetchMeEvent(now: DateTime.now(), force: true));
        }
      }
    });
  }

  static User extractMe(MeState state) {
    if (state is LoadedMeState) {
      return state.me;
    } else {
      // This should never happen and we should probably throw an error here?
      return null;
    }
  }

  @override
  Stream<MeState> mapEventToState(
    MeEvent event,
  ) async* {
    final currentState = this.state;
    if (event is FetchMeEvent &&
        (event.force || !(currentState is LoadedMeState))) {
      try {
        final me = await repository.getMe();
        if (me != null) {
          Segment.identify(userId: me.id);
        }
        yield LoadedMeState(me, DateTime.now());
      } catch (err) {
        print('caught error ${err}');
      }
    }
    if (event is LogoutMeEvent) {
      yield MeInitial();
    }
  }
}
