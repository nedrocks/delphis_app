import 'package:bloc/bloc.dart';

class ChathamBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('bloc: ${bloc} transition: ${transition.event}');
    super.onTransition(bloc, transition);
  }
}
