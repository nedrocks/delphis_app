import 'package:flutter/material.dart';
import 'package:delphis_app/widgets/app_button/index.dart';

class LoginWithTwitterButton extends StatelessWidget {
  VoidCallback onPressed;

  LoginWithTwitterButton({
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      buttonName: "Login With Twitter",
      onPressed: this.onPressed,
      buttonTextStyle: null
    );
  }
}