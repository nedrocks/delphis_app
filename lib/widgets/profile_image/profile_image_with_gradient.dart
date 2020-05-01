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
  final bool isAnonymous;
  final double width;
  final double height;
  final bool isPressable;
  final VoidCallback onPressed;

  const ProfileImageWithGradient({
    @required this.participant,
    @required this.width,
    @required this.height,
    @required this.isAnonymous,
    this.me,
    this.isPressable = false,
    this.onPressed,
    this.isModerator = false,
  })  : assert(!(isModerator && isAnonymous),
            'Cannot have an anonymous moderator'),
        assert(
            !isModerator || me != null, 'A moderator must pass a `me` object'),
        assert(!isPressable || onPressed != null,
            'If pressable, must pass onPressed'),
        super();

  @override
  Widget build(BuildContext context) {
    final participantID =
        this.participant == null ? 0 : this.participant.participantID;
    final gradient = ChathamColors.gradients[
        anonymousGradients[participantID % anonymousGradients.length]];
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
    if (this.isAnonymous) {
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
