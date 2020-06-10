import 'dart:async';
import 'package:delphis_app/bloc/auth/auth_bloc.dart';
import 'package:delphis_app/constants.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  AuthBloc authBloc;

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
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {});

    _onStateChanged = flutterWebviewPlugin.onStateChanged
        .listen((WebViewStateChanged state) {});

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          if (url.startsWith(Constants.twitterRedirectURLPrefix)) {
            RegExp regExp = RegExp("\\?dc=(.*)");
            this.token = regExp.firstMatch(url)?.group(1);
            this.authBloc.add(LoadedAuthEvent(this.token, true, false));

            this.successfulLogin();
          }
        });
      }
    });
  }

  void successfulLogin() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/Home', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (this.authBloc == null) {
          if (state is InitializedAuthState && state.isAuthed) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              this.successfulLogin();
            });
            return Text('Redirecting...');
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            setState(() {
              this.authBloc = BlocProvider.of<AuthBloc>(context);
            });
          });
          return Text('Loading');
        }
        String loginUrl = Constants.twitterLoginURL;
        if (state is InitializedAuthState && state.isAuthed) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            this.successfulLogin();
          });
          return Text('Redirecting...');
        } else {
          return WebviewScaffold(
            url: loginUrl,
            appBar: AppBar(
              title: Text("Login to Chatham"),
            ),
          );
        }
        ;
      },
    );
  }
}
