//https://stackoverflow.com/questions/53278792/sliding-animation-to-bottom-in-flutter
import 'package:flutter/material.dart';

import 'discussion_popup.dart';

class AnimatedDiscussionPopup extends StatefulWidget {
  final Widget child;
  final DiscussionPopup popup;
  final int animationMillis;
  final VoidCallback onForwardAnimationComplete;
  final VoidCallback onReverseAnimationComplete;

  const AnimatedDiscussionPopup(
      {@required this.child,
      @required this.popup,
      @required this.animationMillis,
      this.onForwardAnimationComplete,
      this.onReverseAnimationComplete})
      : super();

  @override
  State<StatefulWidget> createState() => AnimatedDiscussionPopupState();
}

class AnimatedDiscussionPopupState extends State<AnimatedDiscussionPopup>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> offset;
  bool _isForwardAnimation;

  @override
  void initState() {
    super.initState();

    this._isForwardAnimation = true;

    this.controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: this.widget.animationMillis))
      ..addStatusListener((AnimationStatus state) {
        if (state == AnimationStatus.forward) {
          this.setState(() {
            this._isForwardAnimation = true;
          });
        } else if (state == AnimationStatus.reverse) {
          this.setState(() {
            this._isForwardAnimation = false;
          });
        } else if (state == AnimationStatus.completed) {
          if (this._isForwardAnimation &&
              this.widget.onForwardAnimationComplete != null) {
            this.widget.onForwardAnimationComplete();
          } else if (!this._isForwardAnimation &&
              this.widget.onReverseAnimationComplete != null) {
            this.widget.onReverseAnimationComplete();
          }
        }
      });

    this.offset = Tween<Offset>(begin: Offset(0.0, 0.6), end: Offset.zero).chain(CurveTween(curve: Curves.ease))
        .animate(controller);
    this.controller.forward();
  }

  @override
  void dispose() {
    this.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      this.widget.child,
      Align(
          alignment: Alignment.bottomCenter,
          child: SlideTransition(
            position: this.offset,
            child: this.widget.popup,
          ))
    ]);
  }
}
