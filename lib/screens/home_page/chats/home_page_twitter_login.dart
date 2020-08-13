import 'package:delphis_app/bloc/auth/auth_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/auth/base/widgets/loginWithTwitterButton/twitter_button.dart';
import 'package:delphis_app/widgets/animated_size_container/animated_size_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomePageTwitterLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: SpacingValues.xxxxLarge),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Intl.message(
                  "Looks like you haven’t been invited to any discussions."),
              style: TextThemes.onboardHeading,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SpacingValues.small),
            Text(
              Intl.message(
                  "Tell us who you are so we can look up your pending invites on social media."),
              style: TextThemes.onboardBody,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SpacingValues.mediumLarge),
            AnimatedSizeContainer(
              builder: (context) {
                return BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is LoadingAuthState) {
                      return Container(
                        margin: EdgeInsets.only(bottom: SpacingValues.large),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is ErrorAuthState) {
                      return Container(
                        margin: EdgeInsets.only(bottom: SpacingValues.large),
                        child: Center(
                          child: Text(
                            state.error.toString(),
                            textAlign: TextAlign.center,
                            style: TextThemes.discussionPostText.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                );
              },
            ),
            LoginWithTwitterButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context)
                    .add(TwitterSignInAuthEvent());
              },
              width: double.infinity,
              height: 56.0,
            ),
            SizedBox(height: SpacingValues.xxLarge),
            Text(
              Intl.message(
                  "While discussion participants are anonymous to each other, you are invited by the moderator using your real identity."),
              style: TextThemes.discussionPostText,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SpacingValues.smallMedium),
            Text(
              Intl.message(
                  "We verify that it’s you when you join a chat, but during the discussion, even the moderator doesn’t know who you are - they just know that everyone participating was someone they invited."),
              style: TextThemes.discussionPostText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
