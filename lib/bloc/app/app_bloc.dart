import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial());

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is AppLifecycleChanged) {
      yield AppLoadedState(lifecycleState: event.lifecycle);
    }
  }
}
