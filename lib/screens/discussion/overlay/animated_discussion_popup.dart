//https://stackoverflow.com/questions/53278792/sliding-animation-to-bottom-in-flutter
import 'package:flutter/material.dart';

import 'discussion_popup.dart';

class AnimatedDiscussionPopup extends StatefulWidget {
  final Widget child;
  final DiscussionPopup popup;
  final int animationSeconds;

  const AnimatedDiscussionPopup({
    this.child,
    this.popup,
    this.animationSeconds,
  }): super();

  @override
  State<StatefulWidget> createState() => AnimatedDiscussionPopupState();
}

class AnimatedDiscussionPopupState extends State<AnimatedDiscussionPopup> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> offset;

  @override
  void initState() {
    super.initState();

    this.controller = AnimationController(vsync: this, duration: Duration(seconds: this.widget.animationSeconds));

    this.offset = Tween<Offset>(begin: Offset(0.0, 0.6), end: Offset.zero).animate(controller);
  }

  @override
  void dispose() {
    this.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.controller.forward();
    return Stack(
      children: <Widget>[
        this.widget.child,
        Align(
          alignment: Alignment.bottomCenter,
          child: SlideTransition(
            position: this.offset,
            child: this.widget.popup,
          )
        )
      ]
    );
  }
}