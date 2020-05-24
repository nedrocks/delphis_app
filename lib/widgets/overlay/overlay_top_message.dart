import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'overlay_builder.dart';

class OverlayTopMessage extends StatefulWidget {
  final Widget child;
  final int showForMs;
  final int fadeTimeMs;
  final VoidCallback onDismiss;

  OverlayTopMessage({
    @required this.child,
    this.showForMs = 1000,
    this.fadeTimeMs = 500,
    this.onDismiss,
  }) : super();

  @override
  State<StatefulWidget> createState() => _OverlayTopMessageState();
}

enum OverlayMessageState {
  FADE_IN,
  IS_SHOWING,
  FADE_OUT,
  DONE,
}

class _OverlayTopMessageState extends State<OverlayTopMessage> {
  OverlayMessageState _showState;
  double _opacity;

  bool _isShowing;
  OverlayEntry _entry;

  @override
  void initState() {
    super.initState();
    this._isShowing = false;
    this._showState = OverlayMessageState.FADE_IN;
    this._opacity = 0.0;
    //this.insertOverlay();
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      this.setState(() {
        this._opacity = 1.0;
        this._isShowing = true;
      });
    });
  }

  void fadeOutComplete() {
    this._entry?.remove();
    this._entry = null;
    this.widget.onDismiss();
  }

  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: this.widget.fadeTimeMs),
        child: this.widget.child,
        opacity: this._opacity,
        curve: Curves.decelerate,
        onEnd: () {
          if (this._showState == OverlayMessageState.FADE_IN) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              this._showState = OverlayMessageState.IS_SHOWING;
              Future.delayed(Duration(milliseconds: this.widget.showForMs))
                  .then((_) {
                this.setState(() {
                  this._showState = OverlayMessageState.FADE_OUT;
                  this._opacity = 0.0;
                });
              });
            });
          } else if (this._showState == OverlayMessageState.FADE_OUT) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              this.setState(() {
                this._showState = OverlayMessageState.DONE;
                this.fadeOutComplete();
              });
            });
          }
        },
      ),
    );
  }
}
