import 'package:flutter/material.dart';

class ModeratorStar extends StatelessWidget {
  final double height;
  final double width;

  const ModeratorStar({
    @required this.height,
    @required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.contain,
          image: AssetImage('assets/images/star_white_border/image.png'),
        ),
      ),
    );
  }
}
