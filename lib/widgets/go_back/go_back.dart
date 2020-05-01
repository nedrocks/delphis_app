import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class GoBack extends StatelessWidget {
  final VoidCallback onPressed;
  final double height;

  const GoBack({
    @required this.onPressed,
    @required this.height,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: this.onPressed,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/back_chevron.svg',
                    color: Color.fromRGBO(81, 82, 88, 1.0),
                    height: this.height,
                  ),
                  SizedBox(width: SpacingValues.small),
                  Text(Intl.message('Back'), style: TextThemes.backButton),
                ])));
  }
}
