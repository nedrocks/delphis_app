part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
}

class NotificationInitial extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationInitialized extends NotificationState {
  final List<Widget> notifications;

  NotificationInitialized({
    @required this.notifications,
  });

  @override
  List<Object> get props => [this.notifications];

  NotificationInitialized copyWith({List<Widget> notifications}) {
    return NotificationInitialized(
      notifications: notifications ?? this.notifications,
    );
  }

  NotificationInitialized addNotification(Widget notif) {
    final updatedNotifications = this.notifications..add(notif);
    return this.copyWith(notifications: updatedNotifications);
  }
}

class NotificationShowing extends NotificationInitialized {
  final OverlayEntry overlayEntry;
  final ChathamOverlayBuilder showingNotification;
  final bool showNextOnDismiss;

  NotificationShowing({
    @required this.overlayEntry,
    @required this.showingNotification,
    @required notifications,
    this.showNextOnDismiss = false,
  }) : super(notifications: notifications);

  @override
  List<Object> get props =>
      super.props + [this.showingNotification, this.showNextOnDismiss];

  @override
  NotificationShowing copyWith(
      {List<Widget> notifications,
      OverlayEntry overlayEntry,
      ChathamOverlayBuilder showingNotification,
      bool showNextOnDismiss}) {
    return NotificationShowing(
        overlayEntry: overlayEntry ?? this.overlayEntry,
        notifications: notifications ?? this.notifications,
        showingNotification: showingNotification ?? this.showingNotification,
        showNextOnDismiss: showNextOnDismiss ?? this.showNextOnDismiss);
  }
}
