import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/widgets/overlay/overlay_builder.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GlobalKey<NavigatorState> navKey;

  NotificationBloc({@required this.navKey});

  @override
  NotificationState get initialState =>
      NotificationInitialized(notifications: []);

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    final currentState = this.state;
    if (currentState is NotificationInitialized &&
        event is NewNotificationEvent) {
      yield currentState.addNotification(event.notification);
      this.add(ShowNextNotification(
          toShow: ChathamOverlayBuilder(
              embeddedWidget: event.notification,
              overlayBuilder: (context) => event.notification,
              showOverlay: true)));
      return;
    }
    // Because we have inheritance the order matters here.
    if (event is ShowNextNotification &&
        currentState is NotificationInitialized) {
      // We need to dismiss and then show.
      if (currentState is NotificationShowing &&
          !currentState.showNextOnDismiss) {
        final newState = currentState.copyWith(showNextOnDismiss: true);
        yield newState;
        if (currentState.runtimeType == NotificationShowing) {
          this.add(DismissNotification());
        }
      } else if (currentState.runtimeType == NotificationInitialized) {
        if (currentState.notifications == null ||
            currentState.notifications.length == 0) {
          // Nothing we can do here
          return;
        }
        // The one we're about to show may not be the next in the list. Verify it exists and then
        // remove it from the list!
        if (!currentState.notifications.remove(event.toShow.embeddedWidget)) {
          // Widget was not found in list. Again nothing to do.
          return;
        }
        final overlayEntry = OverlayEntry(builder: event.toShow.overlayBuilder);
        this.navKey.currentState.overlay.insert(overlayEntry);
        yield NotificationShowing(
            overlayEntry: overlayEntry,
            showingNotification: event.toShow,
            notifications: currentState.notifications,
            showNextOnDismiss: false);
      }
    }

    if (event is DismissNotification && currentState is NotificationShowing) {
      if (currentState.overlayEntry != null) {
        currentState.overlayEntry.remove();
      }
      yield NotificationInitialized(notifications: currentState.notifications);
    }
  }
}
