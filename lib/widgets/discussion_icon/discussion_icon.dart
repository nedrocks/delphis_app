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
    if (this.imageURL != null && this.imageURL != '') {
      final isEmoji = this.imageURL.startsWith("emoji://");
      return Container(
          width: this.width,
          height: this.height,
          child: isEmoji
              ? Text(this.imageURL.substring("emoji://".length),
                  style:
                      TextStyle(fontSize: this.height * 5 / 6, height: 6 / 5))
              : Image.network(this.imageURL));
    } else {
      return Container(
          width: this.width,
          height: this.height,
          child: Image.asset('assets/images/app_icon/image.png'));
    }
  }
}
