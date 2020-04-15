import 'package:delphis_app/bloc/delegate.dart';
import 'package:delphis_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'data/repository/auth.dart';

import 'chatham_app.dart';

FlutterSecureStorage storage = FlutterSecureStorage();
DelphisAuthRepository delphisAuth = DelphisAuthRepository(storage);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Constants.setEnvironment(Environment.STAGING);
  BlocSupervisor.delegate = ChathamBlocDelegate();
  delphisAuth.loadFromStorage().then((_) {
    runApp(MultiProvider(
        providers: [
          // This needs to be at the top level because it affects the entire
          // app.
          ChangeNotifierProvider<DelphisAuthRepository>(create: (context) => delphisAuth),
        ],
        child: ChathamApp(),
      ));
  });
}