import 'package:delphis_app/widgets/anon_profile_image/anon_profile_image.dart';
import 'package:delphis_app/widgets/gradient_border/gradient_border.dart';
import 'package:flutter/material.dart';

class DelphisInputButton extends StatelessWidget {
  final VoidCallback onClick;
  final double width;
  final double height;

  const DelphisInputButton({
    this.onClick,
    this.width,
    this.height,
  }): super();

  @override
  Widget build(BuildContext context) {
    var gradient = LinearGradient(
      colors: [Color.fromRGBO(30, 60, 236, 1.0), Color.fromRGBO(93, 170, 251, 1.0)],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    );
    var borderRadius = 13.0;
    return Container(
      height: this.height,
      width: this.width,
      child: GradientBorder(
        borderRadius: borderRadius,
        gradient: gradient,
        borderWidth: 1.5,
        boxShape: BoxShape.rectangle,
        child: Stack(
          children: <Widget>[
            AnonProfileImage(
              borderShape: BoxShape.rectangle,
              borderRadius: borderRadius,
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                  highlightColor: Colors.red.withOpacity(0.5),
                  splashColor: Colors.red.withOpacity(0.4),
                  onTap: this.onClick,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}