import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';

class CheckListOption extends StatelessWidget {
  final bool isSelected;
  final String text;
  final VoidCallback onTap;

  const CheckListOption({Key key, this.isSelected, this.text, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final checkMarkSize = 24.0;
    final borderWidth = 2.0;
    Widget checkMark = Container(
      margin: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: borderWidth, color: Colors.white)),
      width: checkMarkSize - borderWidth * 2,
      height: checkMarkSize - borderWidth * 2,
    );
    if (this.isSelected) {
      checkMark =
          Icon(Icons.check_circle, color: Colors.white, size: checkMarkSize);
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
          onTap: this.onTap,
          child: Container(
            padding: EdgeInsets.all(SpacingValues.small),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                checkMark,
                SizedBox(width: SpacingValues.large),
                Flexible(
                  child: Text(this.text, style: TextThemes.onboardBody),
                )
              ],
            ),
          )),
    );
  }
}
