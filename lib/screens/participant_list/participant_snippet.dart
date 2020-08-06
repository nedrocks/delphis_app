import 'package:delphis_app/data/repository/moderator.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/screens/discussion/participants_button.dart';
import 'package:delphis_app/screens/discussion/post_title.dart';
import 'package:delphis_app/widgets/profile_image/moderator_profile_image.dart';
import 'package:delphis_app/widgets/profile_image/profile_image.dart';
import 'package:flutter/material.dart';

class ParticipantSnippet extends StatelessWidget {
  final Participant participant;
  final Moderator moderator;
  final double height;
  final VoidCallback onOptionsTap;
  final bool showOptions;

  ParticipantSnippet({
    @required this.participant,
    @required this.moderator,
    @required this.height,
    this.onOptionsTap,
    this.showOptions,
  });

  @override
  Widget build(BuildContext context) {
    final isModeratorAuthor =
        participant?.userProfile?.id == moderator?.userProfile?.id ?? false;
    Widget profileImage;

    if (isModeratorAuthor) {
      profileImage = ModeratorProfileImage(
          starTopLeftMargin: 21,
          starSize: 12,
          diameter: 32.0,
          profileImageURL: this.moderator.userProfile.profileImageURL);
    } else {
      profileImage = ProfileImage(
          height: 32,
          width: 32,
          profileImageURL: this.participant.userProfile?.profileImageURL,
          isAnonymous: this.participant.isAnonymous);
    }

    return Container(
      height: this.height,
      padding: EdgeInsets.all(SpacingValues.small),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: <Widget>[
                profileImage,
                SizedBox(width: SpacingValues.mediumLarge),
                PostTitle(
                  moderator: this.moderator,
                  participant: this.participant,
                  height: height / 2,
                  isModeratorAuthor: isModeratorAuthor,
                  isParticipantNameColored: false,
                ),
              ],
            ),
          ),
          showOptions
              ? ParticipantsButton(
                  diameter: height / 1.6,
                  onPressed: onOptionsTap,
                  isVertical: true,
                )
              : Container(),
        ],
      ),
    );
  }
}
