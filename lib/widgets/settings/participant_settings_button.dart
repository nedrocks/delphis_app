import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/widgets/anon_profile_image/anon_profile_image.dart';
import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:delphis_app/widgets/profile_image/moderator_profile_image.dart';
import 'package:flutter/material.dart';

class ParticipantSettingsButton extends StatelessWidget {
  final VoidCallback onClick;
  final double width;
  final double height;
  final Discussion discussion;
  final User me;
  final bool isModerator;
  final Participant participant;

  const ParticipantSettingsButton({
    @required this.onClick,
    @required this.width,
    @required this.height,
    @required this.discussion,
    @required this.me,
    @required this.isModerator,
    @required this.participant,
  }) : super();

  Widget _getProfileImage(User me, double borderRadius) {
    if (this.isModerator) {
      // Me is the moderator
      return ModeratorProfileImage(
        diameter: this.width,
        profileImageURL: me.profile.profileImageURL,
        outerBorderWidth: 1.0,
      );
    }
    // Is anonymous
    if (true) {
      return AnonProfileImage(
        width: this.width,
        height: this.height,
        borderShape: BoxShape.rectangle,
        borderRadius: borderRadius,
      );
    } else {
      // Is not anonymous
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final participantID =
        this.participant == null ? 0 : this.participant.participantID;
    final gradient = ChathamColors.gradients[
        anonymousGradients[participantID % anonymousGradients.length]];
    final borderRadius = this.width / 3.0;
    final profileImage = this._getProfileImage(me, borderRadius);
    return Pressable(
      onPressed: this.onClick,
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        gradient: gradient,
        shape: this.isModerator ? BoxShape.circle : BoxShape.rectangle,
        border: this.isModerator
            ? null
            : Border.all(
                color: Colors.transparent,
                width: 1.5,
              ),
        borderRadius: this.isModerator
            ? null
            : BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: profileImage,
    );
  }
}
