import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

part 'link_event.dart';
part 'link_state.dart';

class LinkBloc extends Bloc<LinkEvent, LinkState> {
  static const urlLinkRegex =
      r"(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#[\]@!\$&'\(\)\*\+,;=.]+";

  LinkBloc() : super(ExternalLinkState());

  @override
  Stream<LinkState> mapEventToState(
    LinkEvent event,
  ) async* {
    if (event is LinkChangeEvent && event.newLink != null) {
      try {
        Uri linkUri = Uri.parse(event.newLink);
        if (!linkUri.hasScheme) {
          linkUri = Uri.parse("https://${event.newLink}");
        }
        if (linkUri.host != "m.chatham.ai") {
          if (await canLaunch(linkUri.toString())) {
            await launch(linkUri.toString(), forceSafariVC: false);
            return;
          }
        }
      } catch (error) {
        // We just keep going in this case
      }
      yield ExternalLinkState(link: event.newLink, nonce: event.nonce);
    } else if (event is ClearLinkEvent) {
      yield EmptyLinkState();
    }
  }
}
