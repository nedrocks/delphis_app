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
  final DateTime now;

  const LoadedMeState(this.me, this.now);

  @override
  List<Object> get props => [this.me.id, this.now];
}
