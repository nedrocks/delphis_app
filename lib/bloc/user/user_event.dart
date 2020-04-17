part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class FetchMeUserEvent extends UserEvent {
  const FetchMeUserEvent(): super();

  @override
  List<Object> get props => [];
}