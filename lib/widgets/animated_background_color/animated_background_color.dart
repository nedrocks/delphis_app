import 'package:flutter/material.dart';

class AnimatedBackgroundColor extends StatefulWidget {
  final Widget child;
  final Color startColor;
  final Color endColor;
  final bool repeat;
  final Duration duration;
  
  const AnimatedBackgroundColor({
    Key key,
    this.child,
    @required this.startColor,
    @required this.endColor,
    this.repeat = false,
    @required this.duration
  }) : super(key: key);

  @override
  _AnimatedBackgroundColorState createState() => _AnimatedBackgroundColorState();
}

class _AnimatedBackgroundColorState extends State<AnimatedBackgroundColor>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: this.widget.duration,
      vsync: this,
    );
    if(this.widget.repeat)
      _controller.repeat();
    else
      _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Animatable<Color> background = TweenSequence<Color>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: widget.startColor,
        end: widget.endColor,
      ),
    ),
  ]);
    return AnimatedBuilder(
      animation: _controller,
      child: this.widget.child,
      builder: (context, child) {
        return Container(
          color: background.evaluate(AlwaysStoppedAnimation(_controller.value)),
          child: child,
        );
      });
  }
}