import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CircularSelectionCheckmark extends StatelessWidget {
  static const _BORDER_COLOR = Color.fromRGBO(11, 12, 16, 1.0);

  final bool isSelected;
  final double radius;

  const CircularSelectionCheckmark({
    this.isSelected,
    @required this.radius,
  }) : super();

  @override
  Widget build(BuildContext context) {
    if (this.isSelected) {
      return Container(
        width: this.radius * 2.0,
        height: this.radius * 2.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: _BORDER_COLOR, width: 1.0)),
        padding: EdgeInsets.all(1.5),
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: _BORDER_COLOR, width: 1.0)),
          padding: EdgeInsets.all(3.0),
          child: SvgPicture.asset('assets/svg/check_mark.svg',
              color: Colors.black, semanticsLabel: 'Selected'),
        ),
      );
    } else {
      return Container(
        width: this.radius * 2.0,
        height: this.radius * 2.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Color.fromRGBO(200, 200, 207, 0.48)),
      );
    }
  }
}
