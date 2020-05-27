import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final int notificationCount;
  final Color backgroundColor;
  final double diameter;

  const NotificationBadge({
    @required this.notificationCount,
    @required this.diameter,
    this.backgroundColor = Colors.transparent,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: this.backgroundColor,
      ),
      padding: EdgeInsets.all(3.0),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: ChathamColors.notificationIconGradient,
          shape: BoxShape.circle,
        ),
        child: Text(this.notificationCount.toString(),
            style: TextThemes.notificationBadgeText),
      ),
    );
  }
}
