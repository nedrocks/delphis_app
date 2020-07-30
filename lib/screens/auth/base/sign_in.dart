import 'package:delphis_app/bloc/auth/auth_bloc.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/auth/base/widgets/apple_signin.dart';
import 'package:delphis_app/screens/auth/base/widgets/loginWithTwitterButton/twitter_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInScreen extends StatelessWidget {
  static const twitterWidgetHeight = 76.0;
  static const feedbackLink =
      'mailto:ned@chatham.ai?subject=Twitter%20Makes%20Me%20Mad';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignedInAuthState) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/Home', (Route<dynamic> route) => false);
        }
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.black,
          body: Container(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(horizontal: SpacingValues.xxxxLarge),
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return SizedBox(
                height: constraints.maxHeight * 0.7,
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset('assets/svg/twitter_logo.svg',
                        color: ChathamColors.signInTwitterBackground,
                        semanticsLabel: 'Twitter Logo',
                        width: 96,
                        height: twitterWidgetHeight),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          Intl.message(
                              "The app works best with Twitter, but if you're an Apple user you can sign in with Apple to explore discussions."),
                          style: TextThemes.onboardHeading,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: SpacingValues.small),
                        Text(
                            Intl.message(
                                "Sign in to get smart recs on who to chat with and what to chat about. Sorry for the limitations — we're a small team right now."),
                            style: TextThemes.onboardBody,
                            textAlign: TextAlign.center),
                        SizedBox(height: SpacingValues.mediumLarge),
                        Column(
                          children: [
                            LoginWithTwitterButton(
                              onPressed: () {
                                BlocProvider.of<AuthBloc>(context)
                                    .add(TwitterSignInAuthEvent());
                              },
                              width: constraints.maxWidth,
                              height: 56.0,
                            ),
                            SizedBox(height: SpacingValues.small),
                            SignInWithAppleButton(
                              onLoginSuccessful: (token) {
                                BlocProvider.of<AuthBloc>(context)
                                    .add(SetTokenAuthEvent(token));
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: SpacingValues.large),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: Intl.message('Write us an angry note'),
                                style: TextThemes.signInAngryNote,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    if (await canLaunch(feedbackLink)) {
                                      launch(feedbackLink);
                                    } else {
                                      throw 'Could not launch mailto URL.';
                                    }
                                  },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
