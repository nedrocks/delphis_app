import 'package:delphis_app/data/repository/moderator.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/screens/discussion/post_title.dart';
import 'package:delphis_app/widgets/anon_profile_image/anon_profile_image.dart';
import 'package:delphis_app/widgets/profile_image/moderator_profile_image.dart';
import 'package:delphis_app/widgets/profile_image/profile_image.dart';
import 'package:flutter/material.dart';

class ParticipantMentionHintWidget extends StatelessWidget {
  final Participant participant;
  final Moderator moderator;
  final VoidCallback onTap;

  ParticipantMentionHintWidget({
    @required this.participant,
    @required this.moderator,
    this.onTap
  });
  
  @override
  Widget build(BuildContext context) {
    Widget profileImage;
    if(participant.isAnonymous || participant.flair == null) {
      profileImage = AnonProfileImage(height: 32, width: 32);
    }
    else if(participant.participantID == 0) {
      profileImage = ModeratorProfileImage(
        diameter: 32.0,
        outerBorderWidth: 0.0,
        profileImageURL: this.moderator.userProfile.profileImageURL
      );
    }
    else {
      profileImage = ProfileImage(
        width: 32,
        height: 32,
        profileImageURL: participant.flair.imageURL,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if(this.onTap != null)
            this.onTap();
          return true;
        },
        child: Container(
          padding: EdgeInsets.all(SpacingValues.small),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              profileImage,
              SizedBox(width: SpacingValues.small),
              PostTitle(
                moderator: this.moderator,
                participant: this.participant,
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}