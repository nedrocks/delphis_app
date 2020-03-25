import 'package:flutter/material.dart';
import 'screens/auth/index.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    '/TwitterAuth': (BuildContext context) => new LoginScreen()
  };

  // Routes() {
  //   runApp(MaterialApp(
  //     title: 'Delphis Demo',
  //     routes: routes,
  //     home: LoginScreen(),
  //   ));
  // }
}