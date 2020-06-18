import 'package:flutter/material.dart';

class VerifiedCheckmark extends StatelessWidget {
  final double height;
  final double width;

  const VerifiedCheckmark({
    this.height,
    this.width,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: this.height,
        width: this.width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fill,
            image:
                AssetImage('assets/images/circle_check_border_trans/image.png'),
          ),
        ));
  }
}
