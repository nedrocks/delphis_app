import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/widgets/image_widget/image_widget.dart';
import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:flutter/material.dart';

class ModeratorInputButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double height;
  final double width;

  const ModeratorInputButton({
    @required this.onPressed,
    @required this.height,
    @required this.width,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final radiusPixels = this.width * 11.0 / 25.0;
    final borderRadius = BorderRadius.all(Radius.circular(radiusPixels));
    return Pressable(
      onPressed: this.onPressed,
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        gradient: ChathamColors.gradients[GradientName.MOD_PURPLE],
        shape: BoxShape.rectangle,
        borderRadius: borderRadius,
        border: Border.all(color: Colors.transparent, width: 2.0),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: Color.fromRGBO(31, 31, 31, 1.0))),
          Container(
              width: this.width / 3.0,
              height: this.height / 3.0,
              decoration: BoxDecoration(
                // 1/2 of the star
                borderRadius:
                    BorderRadius.all(Radius.circular(this.width / 4.0)),
                color: Colors.white,
              )),
          // Next: Put a white background in the center for the lightning bolt.
          ImageWidget(
            boxShape: BoxShape.rectangle,
            width: this.width * 2 / 3,
            height: this.height * 2 / 3,
            color: Colors.transparent,
            borderRadius: 0.0,
            fit: BoxFit.fill,
            localImagePath: 'assets/images/star_bolt_purple/image.png',
          ),
        ],
      ),
    );
  }
}
