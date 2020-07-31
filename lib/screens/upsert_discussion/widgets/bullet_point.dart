import 'package:flutter/material.dart';

class BulletPoint extends StatelessWidget {
  final Color color;
  final double size;
  final EdgeInsets margin;

  const BulletPoint({
    Key key,
    @required this.color,
    @required this.size,
    @required this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
