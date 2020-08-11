import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:flutter/material.dart';

class ParticipantsButton extends StatelessWidget {
  final double diameter;
  final VoidCallback onPressed;
  final bool isVertical;

  const ParticipantsButton({
    @required this.diameter,
    @required this.onPressed,
    this.isVertical = false,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Pressable(
      height: this.diameter,
      width: this.diameter,
      onPressed: this.onPressed,
      child: Container(
        width: this.diameter,
        height: this.diameter,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.transparent),
        alignment: Alignment.center,
        child: Icon(
          this.isVertical ? Icons.more_vert : Icons.more_horiz,
          size: this.diameter * 0.8,
          color: Color.fromRGBO(200, 200, 207, 1.0),
        ),
      ),
    );
  }
}
