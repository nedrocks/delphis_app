import 'package:delphis_app/data/repository/discussion.dart';
import 'package:flutter/material.dart';

import 'discussion_announcement_post.dart';
import 'discussion_post.dart';

class DiscussionPostListView extends StatelessWidget {
  final ScrollController scrollController;
  final Discussion discussion;
  final bool isVisible;

  const DiscussionPostListView({
    @required this.scrollController,
    @required this.discussion,
    this.isVisible = true,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Color.fromRGBO(151, 151, 151, 0.4))),
      ),
      child: ListView.builder(
          key: Key('discussion-posts-' + this.discussion.id),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: this.discussion.posts.length,
          controller: this.scrollController,
          reverse: true,
          itemBuilder: (context, index) {
            final post = DiscussionPost(
              post: this.discussion.posts[index],
              moderator: this.discussion.moderator,
              participant: this.discussion.getParticipantForPostIdx(index),
            );
            if (true) {
              return post;
            } else {
              // TODO: This should be hooked up to announcement posts.
              return DiscussionAnnouncementPost(post: post);
            }
          }),
    );
  }
}
