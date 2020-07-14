import 'package:delphis_app/widgets/profile_image/profile_image.dart';
import 'package:flutter/material.dart';

class ProfileImageAndInviter extends StatelessWidget {
  final String inviterImageURL;
  final Widget child;
  final Gradient gradient;
  final double size;

  const ProfileImageAndInviter({
    Key key, 
    this.inviterImageURL, 
    this.gradient, 
    this.size, 
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(left: size / 3),
            child: child,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: ProfileImage(
            profileImageURL: inviterImageURL,
            isAnonymous: false,
            width: size,
            height: size,
            gradient: gradient,
            gradientWidth: 1,
          ),
        ),
      ],
    );
  }
}