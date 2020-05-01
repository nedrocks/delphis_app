import 'package:flutter/material.dart';

class SlideInTransition extends StatefulWidget {
  final Widget child;
  final int animationMillis;
  final VoidCallback onAnimationComplete;
  final Offset startOffset;

  const SlideInTransition({
    @required this.child,
    @required this.animationMillis,
    @required this.onAnimationComplete,
    this.startOffset = const Offset(0.6, 0.0),
  }) : super();

  @override
  State<StatefulWidget> createState() => _SlideInTransitionState();
}

class _SlideInTransitionState extends State<SlideInTransition>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    this._controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: this.widget.animationMillis),
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          this.widget?.onAnimationComplete();
        }
      });

    this._offset =
        Tween<Offset>(begin: this.widget.startOffset, end: Offset.zero).animate(
            CurvedAnimation(parent: this._controller, curve: Curves.elasticIn));
  }

  @override
  void dispose() {
    super.dispose();
    this._controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: this._offset,
      child: this.widget.child,
    );
  }
}
