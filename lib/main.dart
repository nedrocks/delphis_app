import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:delphis_app/models/auth.dart';

import 'chatham_app.dart';

FlutterSecureStorage storage = FlutterSecureStorage();
DelphisAuth delphisAuth = DelphisAuth(storage);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  delphisAuth.loadFromStorage().then((_) {
    runApp(MultiProvider(
        providers: [
          // This needs to be at the top level because it affects the entire
          // app.
          ChangeNotifierProvider<DelphisAuth>(create: (context) => delphisAuth),
        ],
        child: ChathamApp(),
      ));
  });
}