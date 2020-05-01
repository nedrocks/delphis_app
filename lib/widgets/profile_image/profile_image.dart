import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String profileImageURL;
  final double height;
  final double width;
  final BoxBorder border;
  final Gradient gradient;
  final double gradientWidth;

  const ProfileImage({
    this.profileImageURL,
    this.height,
    this.width,
    this.border,
    this.gradient,
    this.gradientWidth,
  })  : assert(gradient != null
            ? (gradientWidth != null && gradientWidth > 0.0)
            : true),
        super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: this.gradient,
      ),
      padding: (this.gradientWidth != null && this.gradientWidth > 0.0)
          ? EdgeInsets.all(this.gradientWidth)
          : null,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(this.profileImageURL),
          ),
          border: this.border,
        ),
      ),
    );
  }
}
