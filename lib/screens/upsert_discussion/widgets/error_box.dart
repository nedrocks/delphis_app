import 'package:delphis_app/design/sizes.dart';
import 'package:flutter/material.dart';

class ErrorBox extends StatelessWidget {
  final Widget child;

  const ErrorBox({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.red,
      ),
      padding: EdgeInsets.all(SpacingValues.smallMedium),
      child: child,
    );
  }
}
