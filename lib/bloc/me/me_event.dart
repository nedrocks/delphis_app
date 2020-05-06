part of 'me_bloc.dart';

abstract class MeEvent extends Equatable {
  const MeEvent();
}

class FetchMeEvent extends MeEvent {
  const FetchMeEvent() : super();

  @override
  List<Object> get props => [];
}

class LogoutMeEvent extends MeEvent {
  @override
  List<Object> get props => [];
}
