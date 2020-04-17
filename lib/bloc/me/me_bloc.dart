import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:equatable/equatable.dart';

part 'me_event.dart';
part 'me_state.dart';

class MeBloc extends Bloc<MeEvent, MeState> {
  final UserRepository repository;

  MeBloc(this.repository);

  @override
  MeState get initialState => MeInitial();

  @override
  Stream<MeState> mapEventToState(
    MeEvent event,
  ) async* {
    if (event is FetchMeEvent) {
      final me = await repository.getMe();
      yield LoadedMeState(me);
    }
  }
}
