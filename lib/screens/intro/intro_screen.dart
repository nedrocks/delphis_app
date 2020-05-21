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
      Future.delayed(Duration(seconds: 2), () {
        if (isInitialized && state is InitializedAuthState) {
          if (state.isAuthed) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', (Route<dynamic> route) => false);
            });
          } else if (this.isInitialized) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/Auth', (Route<dynamic> route) => false);
            });
          }
        }
      });

      return Container(
        color: Colors.black,
        child: Center(
          child: Image.asset(
            'assets/images/app_icon/image.png',
            width: 60.0,
          ),
        ),
      );
    });
  }
}
