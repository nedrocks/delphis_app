import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:flutter/material.dart';

class MoreButton extends StatelessWidget {
  final double diameter;
  final VoidCallback onPressed;

  const MoreButton({
    @required this.diameter,
    @required this.onPressed,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onPressed: this.onPressed,
      width: this.diameter,
      height: this.diameter,
      decoration: BoxDecoration(
        color: Color.fromRGBO(34, 35, 40, 1.0),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
      ),
      child: Container(
        width: this.diameter,
        height: this.diameter,
        child: Icon(
          Icons.more_horiz,
          size: this.diameter * 0.8,
          color: Color.fromRGBO(200, 200, 207, 1.0),
          semanticLabel: "More...",
        ),
      ),
    );
  }
}
