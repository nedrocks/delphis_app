import 'package:delphis_app/bloc/delegate.dart';
import 'package:delphis_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chatham_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Constants.setEnvironment(Environment.STAGING);
  BlocSupervisor.delegate = ChathamBlocDelegate();
  runApp(ChathamApp());
}