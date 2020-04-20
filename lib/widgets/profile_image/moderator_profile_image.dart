import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/widgets/moderator_star/moderator_star.dart';
import 'package:delphis_app/widgets/profile_image/profile_image.dart';
import 'package:flutter/material.dart';

final Color outerGradientStart = Color.fromRGBO(115, 79, 198, 1.0);
final Color outerGradientEnd = Color.fromRGBO(177, 79, 186, 1.0);
final Color innerGradientStart = Color.fromRGBO(114, 30, 248, 1.0);
final Color innerGradientEnd = Color.fromRGBO(123, 80, 194, 1.0);

// ModeratorProfileImage has 2 borders around it, both with a gradient.
// The outer border has a variable width, followed by a 1.5px black
// spacer and then the profile image with a 1.5px gradient border.
class ModeratorProfileImage extends StatelessWidget {
  static const SCALE_FACTOR = 1.0;
  static const SPACER_SIZE = 1.5;

  final String profileImageURL;
  // Note that the diameter is for the whole widget but
  // the image itself will be (diameter - 2px - borderWidth);
  final double diameter;
  final double outerBorderWidth;

  const ModeratorProfileImage({
    @required this.profileImageURL,
    @required this.diameter,
    this.outerBorderWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    final starDimension = this.diameter * SCALE_FACTOR / 2.5;
    return Container(
      height: this.diameter * SCALE_FACTOR,
      width: this.diameter,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            width: this.diameter,
            height: this.diameter,
            // Outer border child
            child: Container(
              width: this.diameter * SCALE_FACTOR,
              height: this.diameter * SCALE_FACTOR,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(this.diameter / 2.0),
                gradient: ChathamColors.gradients[GradientName.MOD_PURPLE],
              ),
              padding: EdgeInsets.all(this.outerBorderWidth),
              // Spacer child
              child: Container(
                padding: EdgeInsets.all(SPACER_SIZE),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(this.diameter / 2.0),
                  color: Colors.black,
                ),
                child: ProfileImage(
                  width: this.diameter * SCALE_FACTOR - this.outerBorderWidth - SPACER_SIZE,
                  height: this.diameter * SCALE_FACTOR - this.outerBorderWidth - SPACER_SIZE,
                  profileImageURL: this.profileImageURL,
                  gradient: ChathamColors.gradients[GradientName.MOD_PURPLE],
                  gradientWidth: 1.5,
                ),
              ),
            ),
          ),
          Container(
            height: starDimension + 10,
            width: starDimension + 10,
            alignment: Alignment(0.75, 0.75),
            color: Colors.transparent,
            child: ModeratorStar(
              height: starDimension,
              width: starDimension,
            ),
          ),
        ],
      ),
    );
  }

}