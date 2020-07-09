import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class OverlayTopMessage extends StatefulWidget {
  final Widget child;
  final int showForMs;
  final int fadeTimeMs;
  final VoidCallback onDismiss;

  OverlayTopMessage({
    @required this.child,
    this.showForMs = 1000,
    this.fadeTimeMs = 500,
    @required this.onDismiss,
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
      if(!mounted)
        return;
      this.setState(() {
        this._opacity = 1.0;
        this._isShowing = true;
      });
    });
  }

  void fadeOutComplete() {
    this._entry?.remove();
    this._entry = null;
    if (this.widget != null && this.widget.onDismiss != null) {
      this.widget.onDismiss();
    }
  }

  Widget build(BuildContext context) {
    return Directionality(
      // This is not localized but required to remove weird debug issue.
      textDirection: TextDirection.ltr,
      child: SafeArea(
        child: AnimatedOpacity(
          duration: Duration(milliseconds: this.widget.fadeTimeMs),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [this.widget.child],
          ),
          opacity: this._opacity,
          curve: Curves.decelerate,
          onEnd: () {
            if (this._showState == OverlayMessageState.FADE_IN) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                this._showState = OverlayMessageState.IS_SHOWING;
                Future.delayed(Duration(milliseconds: this.widget.showForMs))
                    .then((_) {
                  if(!mounted)
                    return;
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
      ),
    );
  }
}
