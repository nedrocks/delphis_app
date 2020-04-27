import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'gql_event.dart';
part 'gql_state.dart';

class GqlBloc extends Bloc<GqlEvent, GqlState> {
  @override
  GqlState get initialState => GqlInitial();

  @override
  Stream<GqlState> mapEventToState(
    GqlEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
