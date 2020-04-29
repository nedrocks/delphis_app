import 'package:delphis_app/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntroScreen extends StatelessWidget {
  final bool isInitialized;

  IntroScreen({@required this.isInitialized}) : super();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (isInitialized && state is InitializedAuthState) {
        if (state.isAuthed) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          });
        } else if (this.isInitialized) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/Auth', (Route<dynamic> route) => false);
          });
        }
      }
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.rectangle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/app_icon/image.png'),
            ),
          ),
        ),
      );
    });
  }
}
