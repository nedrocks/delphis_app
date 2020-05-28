import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';

class HomePageTopBar extends StatelessWidget {
  final String title;
  final double height;
  final Color backgroundColor;

  const HomePageTopBar({
    @required this.title,
    @required this.height,
    @required this.backgroundColor,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      color: this.backgroundColor,
      padding: EdgeInsets.symmetric(
          horizontal: SpacingValues.xxLarge, vertical: SpacingValues.medium),
      alignment: Alignment.bottomLeft,
      child: Text(this.title, style: TextThemes.homeScreenTitle),
    );
  }
}
