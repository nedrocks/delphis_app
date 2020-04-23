import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:random_words/random_words.dart';

class PostTitle extends StatelessWidget {
  static final chosenNouns = nouns.take(50).toList();
  static final chosenAdjectives = adjectives.take(50).toList();

  final Discussion discussion;
  final int index;

  const PostTitle({
    this.discussion,
    this.index,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final post = this.discussion.posts[this.index];
    final participant = post.participant;
    var now = DateTime.now();
    var difference =
        now.difference(this.discussion.posts[this.index].createdAtAsDateTime());
    var differenceToDisplay = '${difference.inMinutes}m';
    if (difference.inMinutes > 60) {
      differenceToDisplay = '${difference.inHours}h';
      if (difference.inHours > 24) {
        differenceToDisplay = '${difference.inDays}d';
        if (difference.inDays > 30) {
          differenceToDisplay = '>30d';
        }
      }
    }

    var name = Text(
        'Anonymous ${chosenAdjectives[participant.participantID % chosenAdjectives.length]} ${chosenNouns[participant.participantID % chosenNouns.length]}',
        style: TextThemes.discussionPostAuthorAnon);
    if (participant.participantID == 0) {
      // This is the moderator
      name = Text(this.discussion.moderator.userProfile.displayName,
          style: TextThemes.discussionPostAuthorNonAnon);
    }

    return Container(
      child: new Row(
        children: <Widget>[
          name,
          Container(
            padding: EdgeInsets.only(left: SpacingValues.small),
            child: Text(differenceToDisplay,
                style: TextThemes.discussionPostAuthorAnonDescriptor),
          ),
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
