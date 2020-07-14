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
  final String profileImageURL;
  // Note that the diameter is for the whole widget but
  // the image itself will be (diameter - 2px - borderWidth);
  final double diameter;
  final double outerBorderWidth;
  final double starSize;
  final double starTopLeftMargin;
  final bool showAnonymous;

  const ModeratorProfileImage({
    @required this.profileImageURL,
    @required this.diameter,
    this.outerBorderWidth = 1.5,
    @required this.starSize,
    @required this.starTopLeftMargin,
    this.showAnonymous = false
  });

  @override
  Widget build(BuildContext context) {
    final starDimension = this.starSize;
    return Container(
      width: starTopLeftMargin + starDimension,
      height: starTopLeftMargin + starDimension,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Container(
                width: this.diameter,
                height: this.diameter,
                // Outer border
                child: Container(
                  width: this.diameter,
                  height: this.diameter,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        outerGradientStart,
                        outerGradientEnd
                      ]
                    ),
                  ),
                  padding: EdgeInsets.all(this.outerBorderWidth),
                  // Profile image with inner gradient
                  child: ProfileImage(
                    width: this.diameter - this.outerBorderWidth,
                    height: this.diameter - this.outerBorderWidth,
                    profileImageURL: this.profileImageURL,
                    isAnonymous: showAnonymous,
                    gradient: LinearGradient(
                      colors: [
                        innerGradientStart,
                        innerGradientEnd
                      ]
                    ),
                    gradientWidth: 0.5,
                  ),
                ),
              ),
          ),
          Positioned(
            top: starTopLeftMargin ?? 0,
            left: starTopLeftMargin ?? 0,
            child: ModeratorStar(
              height: starDimension,
              width: starDimension,
            ),
          )
        ],
      ),
    );
  }
}
