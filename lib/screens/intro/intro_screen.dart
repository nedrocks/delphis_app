import 'package:delphis_app/bloc/auth/auth_bloc.dart';
import 'package:delphis_app/bloc/gql_client/gql_client_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen() : super();

  bool _navigateIfReady(
      BuildContext context, GqlClientState clientState, AuthState authState) {
    print('clientState: $clientState, authState: $authState');
    if (clientState is GqlClientConnectedState) {
      if (authState is InitializedAuthState && authState.isAuthed) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/', (Route<dynamic> route) => false);
        return true;
      } else if (authState is InitializedAuthState) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/Auth', (Route<dynamic> route) => false);
        return true;
      }
    }
    return false;
  }

  void _navigateWhenReady(
      BuildContext context, GqlClientState clientState, AuthState authState) {
    final isNavigating = this._navigateIfReady(context, clientState, authState);
    if (!isNavigating) {
      Future.delayed(Duration(milliseconds: 200), () {
        _navigateWhenReady(context, clientState, authState);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GqlClientBloc, GqlClientState>(
      listener: (context, state) {
        if (state is GqlClientConnectedState) {
          this._navigateWhenReady(
              context, state, BlocProvider.of<AuthBloc>(context).state);
        }
      },
      child: Container(
        color: Colors.black,
        child: Center(
          child: Image.asset(
            'assets/images/app_icon/image.png',
            width: 60.0,
          ),
        ),
      ),
    );
  }
}
