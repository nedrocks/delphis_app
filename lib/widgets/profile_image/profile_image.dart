import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String profileImageURL;
  final double height;
  final double width;
  final BoxBorder border;

  const ProfileImage({
    this.profileImageURL,
    this.height,
    this.width,
    this.border,
  }): super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(this.profileImageURL),
        ),
        border: this.border,
      )
    );
  }
}