part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
}

class AppLifecycleChanged extends AppEvent {
  final AppLifecycleState lifecycle;
  final DateTime when;

  AppLifecycleChanged({
    @required this.lifecycle,
    when,
  })  : this.when = when ?? DateTime.now(),
        super();

  @override
  List<Object> get props => [this.lifecycle, this.when];
}
