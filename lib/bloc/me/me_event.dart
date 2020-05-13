part of 'me_bloc.dart';

abstract class MeEvent extends Equatable {
  const MeEvent();
}

class FetchMeEvent extends MeEvent {
  final DateTime now;

  FetchMeEvent({
    now,
  })  : this.now = now ?? DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now];
}

class LogoutMeEvent extends MeEvent {
  final DateTime now;

  LogoutMeEvent({
    now,
  })  : this.now = now ?? DateTime.now(),
        super();

  @override
  List<Object> get props => [this.now];
}
