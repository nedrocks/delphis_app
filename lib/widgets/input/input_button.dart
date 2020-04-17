import 'package:delphis_app/bloc/me/me_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/widgets/anon_profile_image/anon_profile_image.dart';
import 'package:delphis_app/widgets/gradient_border/gradient_border.dart';
import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:delphis_app/widgets/profile_image/moderator_profile_image.dart';
import 'package:delphis_app/widgets/profile_image/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DelphisInputButton extends StatelessWidget {
  final VoidCallback onClick;
  final double width;
  final double height;
  final Discussion discussion;
  final User me;
  final bool isModerator;

  const DelphisInputButton({
    @required this.onClick,
    @required this.width,
    @required this.height,
    @required this.discussion,
    @required this.me,
    @required this.isModerator,
  }): super();

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
    final gradient = LinearGradient(
      colors: [Color.fromRGBO(30, 60, 236, 1.0), Color.fromRGBO(93, 170, 251, 1.0)],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    );
    final borderRadius = this.width / 3.0;
    final profileImage = this._getProfileImage(me, borderRadius);
    return Pressable(
      onPressed: this.onClick,
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        gradient: gradient,
        shape: this.isModerator ? BoxShape.circle : BoxShape.rectangle,
        border: this.isModerator ? null : Border.all(
          color: Colors.transparent,
          width: 1.5,
        ),
        borderRadius: this.isModerator ? null : BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: profileImage,
    );
  }
}