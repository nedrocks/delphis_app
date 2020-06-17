import 'package:delphis_app/bloc/delegate.dart';
import 'package:delphis_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chatham_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black, // navigation bar color
      statusBarColor: Colors.black, // status bar color
      statusBarBrightness: Brightness.dark,
    ),
  );
  Constants.setEnvironment(Environment.STAGING);
  BlocSupervisor.delegate = ChathamBlocDelegate();
  runApp(ChathamApp(env: Environment.STAGING));
}
