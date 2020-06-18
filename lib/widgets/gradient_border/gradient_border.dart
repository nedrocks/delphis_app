import 'package:flutter/material.dart';

class GradientBorder extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double borderWidth;
  final BoxShape boxShape;
  final double borderRadius;

  const GradientBorder({
    this.child,
    this.gradient,
    this.borderWidth,
    this.boxShape,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    var decoration = BoxDecoration(
      shape: this.boxShape,
      gradient: this.gradient,
    );
    if (this.boxShape == BoxShape.rectangle) {
      decoration = decoration.copyWith(
          borderRadius: BorderRadius.all(Radius.circular(this.borderRadius)));
    }
    return Container(
      padding: EdgeInsets.all(this.borderWidth),
      decoration: decoration,
      child: this.child,
    );
  }
}
