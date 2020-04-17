part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class LoadedUserState extends UserState {
  final User me;

  const LoadedUserState(this.me);

  @override
  List<Object> get props => [this.me];
}
