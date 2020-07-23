import 'dart:convert';

import 'package:delphis_app/bloc/notification/notification_bloc.dart';
import 'package:delphis_app/constants.dart';
import 'package:delphis_app/util/callbacks.dart';
import 'package:delphis_app/widgets/overlay/overlay_top_message.dart';
import 'package:delphis_app/widgets/text_overlay_notification/incognito_mode_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignInWithAppleButton extends StatefulWidget {
  final AccessTokenCallback onLoginSuccessful;

  const SignInWithAppleButton({
    @required this.onLoginSuccessful,
  }) : super();

  @override
  State<StatefulWidget> createState() => _SignInWithAppleButtonState();
}

class _SignInWithAppleButtonState extends State<SignInWithAppleButton> {
  final Future<bool> _isAvailable = AppleSignIn.isAvailable();

  String errorMessage;

  @override
  void initState() {
    super.initState();
    checkLoggedInState();

    AppleSignIn.onCredentialRevoked.listen((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _isAvailable,
        builder: (context, isAvailable) {
          if (!isAvailable.hasData || !isAvailable.data) {
            return Container();
          }

          return AppleSignInButton(
              onPressed: () {
                logIn(context);
              },
              cornerRadius: 9999.0);
        });
  }

  void createUserNotification(NotificationBloc bloc, String contents) {
    bloc.add(
      NewNotificationEvent(
        notification: OverlayTopMessage(
          child: IncognitoModeTextOverlay(
            hasGoneIncognito: false,
            textOverride: contents,
          ),
          onDismiss: () {
            bloc.add(DismissNotification());
          },
        ),
      ),
    );
  }

  void logIn(BuildContext context) async {
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    final notifBloc = BlocProvider.of<NotificationBloc>(context);

    switch (result.status) {
      case AuthorizationStatus.authorized:

        // Store user ID
        await FlutterSecureStorage()
            .write(key: "userId", value: result.credential.user);

        final authCode =
            Utf8Codec().decode(result.credential.authorizationCode);

        // At this point we need to send the credential token and the auth code to the server.
        // The identity token is signed with a different key than we have access to so we can't
        // use that to prove identity.
        final headers = Map<String, String>();
        final body = Map<String, dynamic>();
        body['e'] = result.credential.email;
        body['fn'] = result.credential.fullName.givenName;
        body['ln'] = result.credential.fullName.familyName;
        body['c'] = authCode;
        final response = await http.post(
          Constants.appleAuthLoginEndpoint,
          headers: headers,
          body: body,
        );

        if (response.statusCode != 200) {
          // There was an error logging in!
          this.createUserNotification(
              notifBloc, "Failed authenticating with Apple. Please try again");
        } else {
          final respBody = json.decode(response.body);
          if (respBody is Map<String, dynamic>) {
            final accessToken = respBody["delphis_access_token"];
            if (accessToken == null || accessToken == "") {
              // An error occurred here.
            } else {
              this.widget.onLoginSuccessful(accessToken);
            }
          } else {
            this.createUserNotification(notifBloc,
                "Failed authenticating with Apple. Please try again");
          }
        }

        break;

      case AuthorizationStatus.error:
        this.createUserNotification(notifBloc,
            "Failed authentication: ${result.error.localizedDescription}");
        break;

      case AuthorizationStatus.cancelled:
        break;
    }
  }

  void checkLoggedInState() async {
    final userId = await FlutterSecureStorage().read(key: "apple_userId");
    if (userId == null) {
      return;
    }

    final credentialState = await AppleSignIn.getCredentialState(userId);
    switch (credentialState.status) {
      case CredentialStatus.authorized:
        break;

      case CredentialStatus.error:
        break;

      case CredentialStatus.revoked:
        break;

      case CredentialStatus.notFound:
        break;

      case CredentialStatus.transferred:
        break;
    }
  }
}
