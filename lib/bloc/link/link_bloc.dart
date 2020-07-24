import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'link_event.dart';
part 'link_state.dart';

class LinkBloc extends Bloc<LinkEvent, LinkState> {
  LinkBloc() : super(ExternalLinkState());

  @override
  Stream<LinkState> mapEventToState(
    LinkEvent event,
  ) async* {
    final currentState = this.state;
    if (event is LinkChangeEvent) {
      yield ExternalLinkState(link: event.newLink, nonce: event.nonce);
    }
  }
}
