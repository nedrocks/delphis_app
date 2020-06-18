import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final TextStyle buttonTextStyle;
  final String buttonName;

  AppButton({
    this.buttonName,
    this.onPressed,
    this.buttonTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
        buttonName,
        textDirection: TextDirection.ltr,
        style: buttonTextStyle,
      ),
      onPressed: onPressed,
    );
  }
}
