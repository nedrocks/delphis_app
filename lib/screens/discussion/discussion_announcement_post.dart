import 'package:flutter/material.dart';

import 'discussion_post.dart';

class DiscussionAnnouncementPost extends StatelessWidget {
  final DiscussionPost post;

  const DiscussionAnnouncementPost({
    @required this.post,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(34, 35, 40, 1.0),
      child: this.post,
    );
  }
}
