import 'dart:convert';

import 'package:delphis_app/constants.dart';
import 'package:delphis_app/util/callbacks.dart';
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

    AppleSignIn.onCredentialRevoked.listen((_) {
      print("Revoked");
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _isAvailable,
        builder: (context, isAvailable) {
          if (!isAvailable.hasData || !isAvailable.data) {
            return Container();
          }

          return AppleSignInButton(onPressed: logIn, cornerRadius: 9999.0);
        });
  }

  void logIn() async {
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:

        // Store user ID
        await FlutterSecureStorage()
            .write(key: "userId", value: result.credential.user);

        print(result.credential);

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
          print("error logging in");
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
            print("failure occurred");
          }
        }

        break;

      case AuthorizationStatus.error:
        print("Sign in failed: ${result.error.localizedDescription}");
        setState(() {
          errorMessage = "Sign in failed 😿";
        });
        break;

      case AuthorizationStatus.cancelled:
        print('User cancelled');
        break;
    }
  }

  void checkLoggedInState() async {
    final userId = await FlutterSecureStorage().read(key: "apple_userId");
    if (userId == null) {
      print("No stored user ID");
      return;
    }

    final credentialState = await AppleSignIn.getCredentialState(userId);
    switch (credentialState.status) {
      case CredentialStatus.authorized:
        print("getCredentialState returned authorized");
        break;

      case CredentialStatus.error:
        print(
            "getCredentialState returned an error: ${credentialState.error.localizedDescription}");
        break;

      case CredentialStatus.revoked:
        print("getCredentialState returned revoked");
        break;

      case CredentialStatus.notFound:
        print("getCredentialState returned not found");
        break;

      case CredentialStatus.transferred:
        print("getCredentialState returned not transferred");
        break;
    }
  }
}
