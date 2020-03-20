import 'dart:async';
import 'package:delphis_app/models/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  String token;

  DelphisAuth auth;

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
    });

    _onStateChanged = flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          // TODO: This should be set in a setting somewheres rather than hardcoded.
          if (url.startsWith("https://app-staging.delphishq.com")) {
            RegExp regExp = new RegExp("\\?dc=(.*)");
            this.token = regExp.firstMatch(url)?.group(1);
            // TODO: Save the token somewhere
            this.auth.authString = this.token;

            Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: This should be in constants or sth
    String loginUrl = "https://staging.delphishq.com/twitter/login";
    this.auth = Provider.of<DelphisAuth>(context);

    return new WebviewScaffold(
        url: loginUrl,
        appBar: new AppBar(
          title: new Text("Login to Delphis"),
        ));
  }
}