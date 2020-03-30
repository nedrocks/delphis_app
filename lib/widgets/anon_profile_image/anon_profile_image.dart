import 'package:flutter/material.dart';

class AnonProfileImage extends StatelessWidget {
  final double height;
  final double width;

  final BoxShape borderShape;
  final double borderRadius;
  final BoxBorder border;

  const AnonProfileImage({
    this.height,
    this.width,
    this.border,
    this.borderShape = BoxShape.circle,
    this.borderRadius = 25.0,
  }): super();

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration = BoxDecoration(
      color: Colors.black,
      shape: this.borderShape,
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage('assets/images/anon_face_transparent/anon_face_transparent.png'),
      ),
    );
    if (this.border != null) {
      decoration = decoration.copyWith(border: this.border);
    }
    if (this.borderShape == BoxShape.rectangle) {
      decoration = decoration.copyWith(borderRadius: BorderRadius.all(Radius.circular(this.borderRadius)));
    }

    return Container(
      height: this.height,
      width: this.width,
      decoration: decoration,
    );
  }
}