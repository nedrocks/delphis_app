import 'package:flutter/material.dart';

class DiscussionPopup extends StatelessWidget {
  final Widget contents;

  const DiscussionPopup({
    this.contents,
  }) : super();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double maxWidgetSize = 7 * screenHeight / 8.0;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxWidgetSize),
      child: this.contents,
    );
  }
}
