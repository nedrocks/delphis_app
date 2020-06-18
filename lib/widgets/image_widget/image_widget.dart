import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final double height;
  final double width;

  final BoxShape boxShape;
  final double borderRadius;
  final BoxBorder border;
  // Maybe have remote image as well?
  final String localImagePath;
  final Color color;
  final BoxFit fit;

  const ImageWidget({
    this.height,
    this.width,
    this.border,
    this.boxShape = BoxShape.circle,
    this.borderRadius = 25.0,
    this.color = Colors.black,
    this.fit = BoxFit.contain,
    @required this.localImagePath,
  }) : super();

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration = BoxDecoration(
      color: this.color,
      shape: this.boxShape,
      image: DecorationImage(
        fit: this.fit,
        image: AssetImage(localImagePath),
      ),
    );
    if (this.border != null) {
      decoration = decoration.copyWith(border: this.border);
    }
    if (this.boxShape == BoxShape.rectangle) {
      decoration = decoration.copyWith(
          borderRadius: BorderRadius.all(Radius.circular(this.borderRadius)));
    }

    return Container(
      height: this.height ?? double.infinity,
      width: this.width ?? double.infinity,
      decoration: decoration,
    );
  }
}
