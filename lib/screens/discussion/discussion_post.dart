import 'package:delphis_app/bloc/mention/mention_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/concierge_content.dart';
import 'package:delphis_app/data/repository/moderator.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:delphis_app/data/repository/post_content_input.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/screens/discussion/concierge_discussion_post_options.dart';
import 'package:delphis_app/widgets/emoji_text/emoji_text.dart';
import 'package:delphis_app/widgets/profile_image/moderator_profile_image.dart';
import 'package:delphis_app/widgets/profile_image/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'post_title.dart';

typedef ConciergePostOptionPressed(
    Post post, ConciergeContent content, ConciergeOption option);

class DiscussionPost extends StatelessWidget {
  final Post post;
  final Participant participant;
  final Moderator moderator;
  final Discussion discussion;

  final int conciergeIndex;
  final int onboardingConciergeStep;

  final ConciergePostOptionPressed onConciergeOptionPressed;

  const DiscussionPost({
    Key key,
    @required this.participant,
    @required this.post,
    @required this.moderator,
    @required this.discussion,
    @required this.conciergeIndex,
    @required this.onboardingConciergeStep,
    @required this.onConciergeOptionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MentionBloc, MentionState> (
      builder: (context, blocState) {
        if(blocState.isReady())
          return buildWithMentionContext(context, blocState);
        return Container();
      },
    );
  }

  Widget buildWithMentionContext(BuildContext context, MentionState mentionContext) {
    final isModeratorAuthor = this.participant?.participantID == 0 ?? false;
    var textWidget = EmojiText(
      text: this.post.content,
      style: Theme.of(context).textTheme.bodyText1,
    );

    /* Color and format mentioned entities */
    textWidget.setTextOperator(MentionState.mentionSpecialCharsRegexPattern, (s) => mentionContext.decodePostContent(s, this.post.mentionedEntities));
    textWidget.setTextOperator(MentionState.encodedMentionRegexPattern, (s) => mentionContext.decodePostContent(s, this.post.mentionedEntities));
    textWidget.setStyleOperator(MentionState.encodedMentionRegexPattern, (s, before, after) {
      var color = Colors.lightBlue;
      if(RegExp(MentionState.unknownMentionRegexPattern).hasMatch(after)) {
        color = Colors.grey;
      }
      return s.copyWith(color: color, fontWeight : FontWeight.bold);
    });
    //textWidget.addOnMatchTapHandler(MentionState.encodedMentionRegexPattern, (s) => print(s)); // POC

    if (this.post.postType == PostType.CONCIERGE &&
        (this.onboardingConciergeStep == null ||
            this.conciergeIndex > this.onboardingConciergeStep)) {
      return Container(width: 0, height: 0);
    }
    return Opacity(
      opacity: (this.post.isLocalPost ?? false) ? 0.4 : 1.0,
      child: Container(
        padding: EdgeInsets.all(SpacingValues.medium),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              key: this.key == null
                  ? null
                  : Key(
                      '${this.key.toString()}-profile-image-padding-container'),
              padding: EdgeInsets.only(right: SpacingValues.medium),
              child: Container(
                key: this.key == null
                    ? null
                    : Key('${this.key.toString()}-profile-image-container'),
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isModeratorAuthor
                      ? ChathamColors.gradients[moderatorGradientName]
                      : ChathamColors.gradients[gradientNameFromString(
                          this.participant.gradientColor)],
                  border: Border.all(color: Colors.transparent, width: 1.0),
                ),
                child: isModeratorAuthor
                    ? ModeratorProfileImage(
                        diameter: 36.0,
                        outerBorderWidth: 0.0,
                        profileImageURL:
                            this.moderator.userProfile.profileImageURL)
                    : ProfileImage(
                        profileImageURL:
                            this.participant.userProfile?.profileImageURL,
                        isAnonymous: this.participant.isAnonymous,
                      ),
              ),
            ),
            Expanded(
                child: Container(
              child: Column(
                key: this.key == null
                    ? null
                    : Key('${this.key.toString()}-content-column'),
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PostTitle(
                    moderator: this.moderator,
                    participant: this.participant,
                    height: 20.0,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: SpacingValues.xxSmall),
                          child: textWidget,
                        ),
                        ConciergeDiscussionPostOptions(
                          participant: this.participant,
                          post: this.post,
                          onConciergeOptionPressed:
                              this.onConciergeOptionPressed,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

}
