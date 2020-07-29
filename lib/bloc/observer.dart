import 'package:bloc/bloc.dart';

class ChathamBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print("$bloc, $transition");
    super.onTransition(bloc, transition);
  }
}
