import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/widgets/anon_profile_image/anon_profile_image.dart';
import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:delphis_app/widgets/profile_image/moderator_profile_image.dart';
import 'package:delphis_app/widgets/profile_image/profile_image.dart';
import 'package:flutter/material.dart';

class ProfileImageWithGradient extends StatelessWidget {
  final User me;
  final Participant participant;
  final bool isModerator;
  final bool anonymousOverride;
  final double width;
  final double height;
  final bool isPressable;
  final VoidCallback onPressed;
  final GradientName gradientNameOverride;

  const ProfileImageWithGradient({
    @required this.participant,
    @required this.width,
    @required this.height,
    this.anonymousOverride,
    this.me,
    this.isPressable = false,
    this.onPressed,
    this.isModerator = false,
    this.gradientNameOverride,
  })  : assert(
            !isModerator || me != null, 'A moderator must pass a `me` object'),
        assert(!isPressable || onPressed != null,
            'If pressable, must pass onPressed'),
        super();

  bool get showAnonymous => anonymousOverride != null
      ? anonymousOverride
      : this.participant.isAnonymous;

  @override
  Widget build(BuildContext context) {
    final participantID =
        this.participant == null ? 0 : this.participant.participantID;
    var gradient = ChathamColors.gradients[
        anonymousGradients[participantID % anonymousGradients.length]];
    if (this.gradientNameOverride != null) {
      gradient = ChathamColors.gradients[this.gradientNameOverride];
    } else if (this.participant.gradientColor != null) {
      gradient = ChathamColors
          .gradients[gradientNameFromString(this.participant.gradientColor)];
    }
    final borderRadius = this.width / 3.0;
    final profileImage = this._getProfileImage(borderRadius);
    // This stinks but currently argument explosion doesn't exist.
    if (this.isPressable) {
      return Pressable(
        onPressed: this.onPressed,
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
    return Container(
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

  Widget _getProfileImage(double borderRadius) {
    if (this.isModerator) {
      // Me is the moderator
      return ModeratorProfileImage(
        diameter: this.width,
        profileImageURL: this.me.profile.profileImageURL,
        outerBorderWidth: 1.0,
      );
    }
    // Is anonymous
    if (this.showAnonymous) {
      return AnonProfileImage(
        width: this.width,
        height: this.height,
        borderShape: BoxShape.rectangle,
        borderRadius: borderRadius,
      );
    } else {
      // Is not anonymous
      return ProfileImage(
        width: this.width,
        height: this.height,
        profileImageURL: this.me.profile.profileImageURL,
      );
    }
  }
}
