import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/widgets/anon_profile_image/anon_profile_image.dart';
import 'package:delphis_app/widgets/profile_image/moderator_profile_image.dart';
import 'package:flutter/material.dart';

import 'post_title.dart';

class DiscussionPost extends StatelessWidget {
  final Discussion discussion;
  final int index;
  final bool isLocalPost;

  const DiscussionPost({
    @required this.discussion,
    @required this.index,
    @required this.isLocalPost,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final post = this.discussion.posts[this.index];
    final isModeratorAuthor = post.participant.participantID == 0;
    return Container(
      color: this.isLocalPost ? Colors.green : Colors.transparent,
      padding: EdgeInsets.only(
          left: SpacingValues.medium,
          top: SpacingValues.medium,
          bottom: SpacingValues.medium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // TODO: We need to hook this up to use the correct image for non-anonymous participants.
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: SpacingValues.medium),
            child: Container(
              width: 36.0,
              height: 36.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isModeratorAuthor
                    ? ChathamColors.gradients[moderatorGradientName]
                    : ChathamColors.gradients[anonymousGradients[this
                            .discussion
                            .posts[this.index]
                            .participant
                            .participantID %
                        anonymousGradients.length]],
                border: Border.all(color: Colors.transparent, width: 2.0),
              ),
              child: isModeratorAuthor
                  ? ModeratorProfileImage(
                      diameter: 36.0,
                      outerBorderWidth: 0.0,
                      profileImageURL:
                          this.discussion.moderator.userProfile.profileImageURL)
                  : AnonProfileImage(),
            ),
          ),
          Expanded(
              child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PostTitle(
                  moderator: this.discussion.moderator,
                  participant:
                      this.discussion.getParticipantForPostIdx(this.index),
                  height: 20.0,
                  post: post,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: SpacingValues.extraSmall),
                        child: Text(
                          '${this.discussion.posts[this.index].content}',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
