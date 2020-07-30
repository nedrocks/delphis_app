import 'dart:async';

import 'package:delphis_app/bloc/auth/auth_bloc.dart';
import 'package:delphis_app/bloc/gql_client/gql_client_bloc.dart';
import 'package:delphis_app/tracking/constants.dart';
import 'package:delphis_app/util/route_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_segment/flutter_segment.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen() : super();

  FutureOr<bool> _navigateIfReady(BuildContext context,
      GqlClientState clientState, AuthState authState) async {
    if (clientState is GqlClientConnectedState) {
      if (authState is SignedInAuthState) {
        var loadedHome = false;
        try {
          var lastRoute =
              await chathamRouteObserverSingleton.retrieveLastRouteName();
          var lastArgs =
              await chathamRouteObserverSingleton.retriveLastRouteArguments();
          Navigator.pushNamedAndRemoveUntil(
              context, '/Home', (Route<dynamic> route) => false);
          loadedHome = true;
          Navigator.pushNamed(context, lastRoute, arguments: lastArgs);
        } catch (error) {
          /* Probably something is broken in the local storage,
             or simply there is no screen history saved.
             In this case we just load the default home page. */
          if (!loadedHome) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/Home', (Route<dynamic> route) => false);
          }
        }
        return true;
      } else if (authState is LoggedOutAuthState) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/Auth', (Route<dynamic> route) => false);
        return true;
      }
    }
    return false;
  }

  void _navigateWhenReady(BuildContext context, GqlClientState clientState,
      AuthState authState) async {
    final isNavigating =
        await this._navigateIfReady(context, clientState, authState);
    if (!isNavigating) {
      Future.delayed(Duration(milliseconds: 200), () {
        _navigateWhenReady(context, clientState, authState);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Segment.track(eventName: ChathamTrackingEventNames.APP_INITIALIZED);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return BlocListener<GqlClientBloc, GqlClientState>(
          listener: (context, gqlState) {
            if (gqlState is GqlClientConnectedState) {
              this._navigateWhenReady(context, gqlState, authState);
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
      },
    );
  }
}
