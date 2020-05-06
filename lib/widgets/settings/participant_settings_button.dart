import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/widgets/profile_image/profile_image_with_gradient.dart';
import 'package:flutter/material.dart';

class ParticipantSettingsButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double width;
  final double height;
  final User me;
  final bool isModerator;
  final Participant participant;

  const ParticipantSettingsButton({
    @required this.onPressed,
    @required this.width,
    @required this.height,
    @required this.me,
    @required this.isModerator,
    @required this.participant,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return ProfileImageWithGradient(
      participant: this.participant,
      isModerator: this.isModerator,
      width: this.width,
      height: this.height,
      me: this.me,
      isPressable: true,
      onPressed: this.onPressed,
    );
  }
}
