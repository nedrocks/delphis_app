import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class LoginWithTwitterButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double width;
  final double height;

  const LoginWithTwitterButton({
    @required this.onPressed,
    @required this.width,
    @required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(this.height / 2.0);
    return Pressable(
      width: this.width,
      height: this.height,
      onPressed: this.onPressed,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: borderRadius,
      ),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color.fromRGBO(247, 247, 255, 1.0),
          borderRadius: borderRadius,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/twitter_logo.svg',
              color: ChathamColors.twitterLogoColor,
              semanticsLabel: 'Twitter Logo',
              width: 28.0,
              height: 23.0,
            ),
            SizedBox(width: SpacingValues.small),
            Text(
              Intl.message('Sign in with Twitter'),
              style: TextThemes.signInWithTwitter,
            ),
          ],
        ),
      ),
    );
  }
}
