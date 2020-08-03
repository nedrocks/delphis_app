import 'package:flutter/material.dart';

class Pressable extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double width;
  final double height;
  final BoxDecoration decoration;
  final bool showInkwell;

  const Pressable({
    @required this.onPressed,
    @required this.child,
    @required this.width,
    @required this.height,
    this.decoration,
    this.showInkwell = true,
  }) : super();

  @override
  Widget build(BuildContext context) {
    Widget wrappedChild;
    if (this.showInkwell) {
      wrappedChild = InkWell(
        borderRadius: this.decoration?.borderRadius,
        onTap: this.onPressed,
      );
    } else {
      wrappedChild = GestureDetector(
        onTap: this.onPressed,
        child: child,
      );
    }

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
              shape: this.decoration?.shape == BoxShape.circle
                  ? CircleBorder()
                  : null,
              borderRadius: this.decoration?.borderRadius,
              color: Colors.transparent,
              child: wrappedChild,
            ),
          ),
        ],
      ),
    );
  }
}
