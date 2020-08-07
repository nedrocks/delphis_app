import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:flutter/material.dart';

class JoinActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final Widget child;
  final EdgeInsets padding;

  const JoinActionButton({
    Key key,
    @required this.onPressed,
    this.color,
    @required this.padding,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Pressable(
      height: null,
      width: double.infinity,
      onPressed: this.onPressed,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Container(
        padding: this.padding,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: this.color ?? Color.fromRGBO(247, 247, 255, 1.0),
          borderRadius: BorderRadius.circular(100.0),
        ),
        alignment: Alignment.center,
        child: this.child,
      ),
    );
  }
}
