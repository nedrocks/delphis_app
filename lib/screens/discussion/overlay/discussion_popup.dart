import 'package:flutter/material.dart';

class DiscussionPopup extends StatelessWidget {
  final Widget contents;

  const DiscussionPopup({
    this.contents,
  }) : super();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double maxWidgetSize = screenHeight / 2.0;

    return Container(
      margin: EdgeInsets.only(top: 60),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxWidgetSize),
        child: this.contents,
      ),
    );
  }
}
