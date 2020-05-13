part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();
}

class AppInitial extends AppState {
  @override
  List<Object> get props => [];
}

class AppLoadedState extends AppState {
  final AppLifecycleState lifecycleState;

  const AppLoadedState({
    @required this.lifecycleState,
  });

  @override
  List<Object> get props => [this.lifecycleState];
}
