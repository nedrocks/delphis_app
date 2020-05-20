import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';

class TextOverlayNotification extends StatelessWidget {
  final Gradient borderGradient;
  final Color borderColor;
  final String text;
  final Widget icon;

  const TextOverlayNotification(
      {@required this.text,
      @required this.icon,
      this.borderGradient,
      this.borderColor})
      : super();

  @override
  Widget build(BuildContext context) {
    var response = Container(
      padding: EdgeInsets.symmetric(
          vertical: SpacingValues.medium, horizontal: SpacingValues.small),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
            color: this.borderGradient != null
                ? Colors.transparent
                : this.borderColor,
            width: 2),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Row(
        children: [
          this.icon ?? Container(width: 0, height: 0),
          SizedBox(width: this.icon == null ? 0 : SpacingValues.medium),
          Expanded(
            child: Text(text, style: TextThemes.textOverlayNotification),
          ),
        ],
      ),
    );
    if (this.borderGradient != null) {
      response = Container(
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            gradient: this.borderGradient,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: response,
      );
    }

    return response;
  }
}
