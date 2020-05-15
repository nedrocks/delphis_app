import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

class DiscussionSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;
  final double width;
  final double height;

  const DiscussionSubmitButton({
    @required this.onPressed,
    @required this.isActive,
    @required this.width,
    @required this.height,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(this.width * 0.4);
    final image = SvgPicture.asset(
      'assets/svg/paper_airplane.svg',
      color: Color.fromRGBO(11, 12, 16, 1.0),
      semanticsLabel: 'Submit',
      width: this.width / 2.0,
      height: this.height / 2.0,
    );
    Widget childWidget = image;
    return Pressable(
      onPressed: this.onPressed,
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: borderRadius,
          color: this.isActive
              ? Color.fromRGBO(246, 246, 246, 1.0)
              : Color.fromRGBO(246, 246, 246, 0.4)),
      child: childWidget,
    );
  }
}
