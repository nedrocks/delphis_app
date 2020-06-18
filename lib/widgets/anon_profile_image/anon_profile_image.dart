import 'package:delphis_app/widgets/image_widget/image_widget.dart';
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
  }) : super();

  @override
  Widget build(BuildContext context) {
    return ImageWidget(
      height: this.height,
      width: this.width,
      boxShape: this.borderShape,
      borderRadius: this.borderRadius,
      border: this.border,
      localImagePath:
          'assets/images/anon_face_transparent/anon_face_transparent.png',
    );
  }
}
