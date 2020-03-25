import 'package:flutter/material.dart';

class DiscussionPopup extends StatelessWidget {
  final Widget contents;

  const DiscussionPopup({
    this.contents,
  }): super();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    // 1/3 of the height of screen. Note that this won't work well
    // if the child is not the full size of the screen (or thereabouts).
    double widgetSize = screenHeight / 3.0;

    return 
      Container(
        height: widgetSize,
        alignment: Alignment.bottomCenter,
        child: this.contents,
      );
  }
}