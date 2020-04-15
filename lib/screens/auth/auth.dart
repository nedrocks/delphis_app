import 'dart:async';
import 'package:delphis_app/constants.dart';
import 'package:delphis_app/data/repository/auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();

  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  String token;

  DelphisAuthRepository auth;

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
          if (url.startsWith(Constants.twitterRedirectURLPrefix)) {
            RegExp regExp = RegExp("\\?dc=(.*)");
            this.token = regExp.firstMatch(url)?.group(1);
            this.auth.authString = this.token;

            this.successfulLogin();
          }
        });
      }
    });
  }

  void successfulLogin() {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    String loginUrl = Constants.twitterLoginURL;
    this.auth = Provider.of<DelphisAuthRepository>(context);

    if (this.auth.isAuthed) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        this.successfulLogin();
      });
      return Text('Redirecting...');
    }

    return WebviewScaffold(
        url: loginUrl,
        appBar: AppBar(
          title: Text("Login to Delphis"),
        ));
  }
}