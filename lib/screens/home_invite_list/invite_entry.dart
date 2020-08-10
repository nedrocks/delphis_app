import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/widgets/discussion_icon/discussion_icon.dart';
import 'package:delphis_app/widgets/profile_image/moderator_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InviteEntry extends StatelessWidget {
  final Discussion discussion;
  final Function(Discussion) onPressed;
  final Function(Discussion) onArchivePressed;

  const InviteEntry({
    Key key,
    @required this.discussion,
    @required this.onPressed,
    @required this.onArchivePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = 60.0;
    if (this.discussion.isDeletedLocally || this.discussion.isArchivedLocally) {
      height = 0.0;
    }
    return Container(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom:
                BorderSide(color: Color.fromRGBO(22, 23, 28, 1.0), width: 1.0),
          ),
        ),
        child: Container(
          height: height,
          padding: EdgeInsets.symmetric(
              vertical: SpacingValues.small, horizontal: SpacingValues.medium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => this.onPressed(this.discussion),
                    child: Row(
                      children: [
                        DiscussionIcon(
                            width: 28,
                            height: 28,
                            imageURL: this.discussion.iconURL),
                        SizedBox(width: SpacingValues.small),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ModeratorProfileImage(
                                      starTopLeftMargin: 12.5,
                                      starSize: 12,
                                      diameter: 22.0,
                                      profileImageURL: this
                                          .discussion
                                          .moderator
                                          .userProfile
                                          .profileImageURL,
                                      outerBorderWidth: 0),
                                  RichText(
                                    text: TextSpan(
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: this
                                                  .discussion
                                                  .moderator
                                                  .userProfile
                                                  .displayName +
                                              ' ',
                                          style:
                                              TextThemes.moderatorNameChatTab,
                                        ),
                                        TextSpan(
                                          text: Intl.message('invites you to'),
                                          style: TextThemes.inviteTextChatTab,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                this.discussion.title,
                                style: TextThemes.discussionTitleChatTab,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: null,
                      height: null,
                      child: RaisedButton(
                        onPressed: () => this.onArchivePressed(this.discussion),
                        child: Text(
                          Intl.message('Archive'),
                          style: TextThemes.joinButtonTextChatTab,
                        ),
                        color: Color.fromRGBO(247, 247, 255, 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(22.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
