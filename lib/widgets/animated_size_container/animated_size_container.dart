import 'package:flutter/material.dart';

class AnimatedSizeContainer extends StatefulWidget {
  final Duration duration;
  final Curve curve;
  final Duration reverseDuration;
  final Widget Function(BuildContext) builder;

  const AnimatedSizeContainer({
    Key key,
    this.duration,
    this.curve,
    this.reverseDuration,
    @required this.builder
  }) : super(key: key) ;
  @override
  _AnimatedSizeContainerState createState() => _AnimatedSizeContainerState();
}

class _AnimatedSizeContainerState extends State<AnimatedSizeContainer> with SingleTickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      vsync: this,
      curve: this.widget.curve ?? Curves.easeInOut,
      duration: this.widget.duration ?? Duration(milliseconds: 200),
      reverseDuration: this.widget.reverseDuration ?? Duration(milliseconds: 200),
      child: this.widget.builder(context),
    );
  }
}