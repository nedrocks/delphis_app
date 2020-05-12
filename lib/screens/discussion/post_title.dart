import 'package:delphis_app/data/repository/moderator.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';

class PostTitle extends StatelessWidget {
  final Moderator moderator;
  final Participant participant;
  final double height;
  final Post post;

  const PostTitle({
    @required this.moderator,
    @required this.participant,
    @required this.height,
    @required this.post,
  }) : super();

  @override
  Widget build(BuildContext context) {
    //var now = DateTime.now();
    // var difference = now.difference(post.createdAtAsDateTime());
    // var differenceToDisplay = '${difference.inMinutes}m';
    // if (difference.inMinutes > 60) {
    //   differenceToDisplay = '${difference.inHours}h';
    //   if (difference.inHours > 24) {
    //     differenceToDisplay = '${difference.inDays}d';
    //     if (difference.inDays > 30) {
    //       differenceToDisplay = '>30d';
    //     }
    //   }
    // }

    // TODO: If the post is an announcement update the name to be something like `The mysterious <name>` with
    // different embedded fonts. the preamble should be the nonAnon text but at 13 font, w400. The name should
    // be the anon text style.
    var name = Text(
        '${participant.gradientColor} #${participant.participantID}',
        style: TextThemes.discussionPostAuthorAnon);
    if (participant.participantID == 0) {
      // This is the moderator
      name = Text(moderator.userProfile.displayName,
          style: TextThemes.discussionPostAuthorNonAnon);
    } else if (!participant.isAnonymous) {
      // Need to pass the profile down from the backend.
    }

    Widget flair = Container(width: 0, height: 0);
    if (participant.flair != null) {
      flair = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: this.height,
            height: this.height,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.transparent,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(participant.flair.imageURL),
              ),
            ),
          ),
          SizedBox(width: SpacingValues.xxSmall),
          Text(
            participant.flair.displayName,
            style: kThemeData.textTheme.headline3,
          )
        ],
      );
    }

    return Container(
      height: this.height,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          name,
          SizedBox(width: SpacingValues.small),
          flair,
          // Container(
          //   padding: EdgeInsets.only(left: SpacingValues.small),
          //   child: Text(differenceToDisplay,
          //       style: TextThemes.discussionPostAuthorAnonDescriptor),
          // ),
          // Container(
          //   padding: EdgeInsets.only(left: SpacingValues.extraSmall, right: SpacingValues.extraSmall),
          //   child: Text('•', style: rhsTextStyle)
          // ),
          // VerifiedProfileImage(
          //   height: 20.0,
          //   width: 20.0,
          //   profileImageURL: this.discussion.moderator.userProfile.profileImageURL,
          //   checkmarkAlignment: Alignment.bottomRight,
          // ),
          // Container(
          //   padding: EdgeInsets.only(left: SpacingValues.xxSmall),
          //   child: Text('Invited by ${this.discussion.moderator.userProfile.displayName}', style: rhsTextStyle),
          // ),
        ],
      ),
    );
  }
}
