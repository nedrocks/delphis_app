import 'package:delphis_app/widgets/anon_profile_image/anon_profile_image.dart';
import 'package:delphis_app/widgets/profile_image/profile_image.dart';
import 'package:delphis_app/widgets/profile_image/verified_profile_image.dart';
import 'package:flutter/material.dart';

class AnonProfileImageWithNonAnon extends StatelessWidget {
  static const double SCALE_FACTOR = 0.85;

  final double height;
  final double width;
  final bool checkmark;
  final String profileImageURL;

  const AnonProfileImageWithNonAnon({
    this.height,
    this.width,
    this.checkmark,
    this.profileImageURL,
  }): super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height * SCALE_FACTOR,
      width: this.width,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            width: this.width,
            height: this.height,
            child: AnonProfileImage(
              height: this.height * SCALE_FACTOR, 
              width: this.width * SCALE_FACTOR,
              border: Border.all(color: Colors.blueGrey),
            ),
          ),
          VerifiedProfileImage(
            height: this.height * SCALE_FACTOR / 2.0, 
            width: this.width * SCALE_FACTOR / 2.0, 
            profileImageURL: this.profileImageURL,
            border: Border.all(color: Colors.blueAccent),
            checkmarkAlignment: Alignment.bottomLeft,
          ),
        ],
      ),
    );
  }
}