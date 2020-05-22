part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class NewNotificationEvent extends NotificationEvent {
  final Widget notification;

  const NewNotificationEvent({@required this.notification}) : super();

  @override
  List<Object> get props => [this.notification];
}

class ShowNextNotification extends NotificationEvent {
  final ChathamOverlayBuilder toShow;

  const ShowNextNotification({
    @required this.toShow,
  }) : super();

  @override
  List<Object> get props => [this.toShow];
}

class DismissNotification extends NotificationEvent {
  final DateTime now;

  DismissNotification()
      : this.now = DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now];
}
