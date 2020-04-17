part of 'me_bloc.dart';

abstract class MeState extends Equatable {
  const MeState();
}

class MeInitial extends MeState {
  @override
  List<Object> get props => [];
}

class LoadedMeState extends MeState {
  final User me;

  const LoadedMeState(this.me);

  @override
  List<Object> get props => [this.me];
}
