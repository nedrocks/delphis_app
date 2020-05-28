import 'package:flutter/material.dart';

class DiscussionIcon extends StatelessWidget {
  final double height;
  final double width;
  final String imageURL;

  const DiscussionIcon({
    @required this.height,
    @required this.width,
    this.imageURL,
  }) : super();

  @override
  Widget build(BuildContext context) {
    if (this.imageURL != null) {
      return Container(
          width: this.width,
          height: this.height,
          child: Image.network(this.imageURL));
    } else {
      return Container(
          width: this.width,
          height: this.height,
          child: Image.asset(
              'assets/images/anon_face_transparent/anon_face_transparent.png'));
    }
  }
}
