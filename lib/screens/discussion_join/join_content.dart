import 'package:delphis_app/bloc/participant/participant_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/discussion_join/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class JoinContent extends StatelessWidget {
  final DiscussionJoinabilityResponse joinability;
  final VoidCallback onBackPressed;
  final VoidCallback onAccessRequestPressed;
  final VoidCallback onJoinPressed;
  const JoinContent({
    Key key,
    @required this.joinability,
    @required this.onBackPressed,
    @required this.onAccessRequestPressed,
    @required this.onJoinPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParticipantBloc, ParticipantState>(
      builder: (context, state) {
        if (state is ParticipantLoaded && state.isUpdating) {
          return Column(
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                height: SpacingValues.extraLarge,
              ),
              JoinActionButton(
                padding: EdgeInsets.all(SpacingValues.mediumLarge),
                onPressed: this.onBackPressed,
                child: Text(
                  Intl.message("Go back"),
                  style: TextThemes.goIncognitoButton
                      .copyWith(color: Colors.black),
                ),
              )
            ],
          );
        }
        if (joinability == DiscussionJoinabilityResponse.DENIED) {
          return Container(
            child: Column(
              children: <Widget>[
                Text(
                  Intl.message(
                      "You cannot access this chat because the moderator declined your participation request."),
                  style: TextThemes.onboardBody.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: SpacingValues.large,
                ),
                JoinActionButton(
                  padding: EdgeInsets.all(SpacingValues.mediumLarge),
                  onPressed: this.onBackPressed,
                  child: Text(
                    Intl.message("Go back"),
                    style: TextThemes.goIncognitoButton
                        .copyWith(color: Colors.black),
                  ),
                )
              ],
            ),
          );
        } else if (joinability ==
            DiscussionJoinabilityResponse.APPROVAL_REQUIRED) {
          return Container(
            child: Column(
              children: <Widget>[
                Text(
                  Intl.message(
                      "An approval from the moderator is required in order to participate in this chat."),
                  style: TextThemes.onboardBody,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: SpacingValues.large,
                ),
                JoinActionButton(
                  padding: EdgeInsets.all(SpacingValues.mediumLarge),
                  color: Colors.blue,
                  onPressed: this.onAccessRequestPressed,
                  child: Text(
                    Intl.message("Request approval"),
                    style: TextThemes.goIncognitoButton
                        .copyWith(color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: SpacingValues.smallMedium,
                ),
                JoinActionButton(
                  padding: EdgeInsets.all(SpacingValues.mediumLarge),
                  onPressed: this.onBackPressed,
                  child: Text(
                    Intl.message("Go back"),
                    style: TextThemes.goIncognitoButton
                        .copyWith(color: Colors.black),
                  ),
                )
              ],
            ),
          );
        } else if (joinability ==
            DiscussionJoinabilityResponse.AWAITING_APPROVAL) {
          return Container(
            child: Column(
              children: <Widget>[
                Text(
                  Intl.message(
                      "Your access request has been sent to the moderator.\nPlease wait for their approval."),
                  style: TextThemes.onboardBody,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: SpacingValues.large,
                ),
                JoinActionButton(
                  padding: EdgeInsets.all(SpacingValues.mediumLarge),
                  onPressed: this.onBackPressed,
                  child: Text(
                    Intl.message("Go back"),
                    style: TextThemes.goIncognitoButton
                        .copyWith(color: Colors.black),
                  ),
                )
              ],
            ),
          );
        } else if (joinability ==
            DiscussionJoinabilityResponse.APPROVED_NOT_JOINED) {
          return Container(
            child: Column(
              children: <Widget>[
                Text(
                  Intl.message(
                      "The moderator approved your participation in this chat."),
                  style: TextThemes.onboardBody,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: SpacingValues.large,
                ),
                JoinActionButton(
                  padding: EdgeInsets.all(SpacingValues.mediumLarge),
                  color: Colors.green,
                  onPressed: this.onJoinPressed,
                  child: Text(
                    Intl.message("Click here to join"),
                    style: TextThemes.goIncognitoButton
                        .copyWith(color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: SpacingValues.smallMedium,
                ),
                JoinActionButton(
                  padding: EdgeInsets.all(SpacingValues.mediumLarge),
                  onPressed: this.onBackPressed,
                  child: Text(
                    Intl.message("Go back"),
                    style: TextThemes.goIncognitoButton
                        .copyWith(color: Colors.black),
                  ),
                )
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
