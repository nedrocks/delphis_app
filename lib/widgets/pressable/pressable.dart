import 'package:flutter/material.dart';

class Pressable extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double width;
  final double height;
  final BoxDecoration decoration;

  const Pressable({
    @required this.onPressed,
    @required this.child,
    @required this.width,
    @required this.height,
    this.decoration,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      alignment: Alignment.center,
      decoration: this.decoration,
      child: Stack(
        children: <Widget>[
          this.child,
          Positioned.fill(
            child: Material(
              shape: this.decoration.shape == BoxShape.circle
                  ? CircleBorder()
                  : null,
              borderRadius: this.decoration.borderRadius,
              color: Colors.transparent,
              child: InkWell(
                borderRadius: this.decoration.borderRadius,
                onTap: this.onPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
