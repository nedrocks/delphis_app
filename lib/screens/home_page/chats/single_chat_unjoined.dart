import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/widgets/discussion_icon/discussion_icon.dart';
import 'package:delphis_app/widgets/profile_image/moderator_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleChatUnjoined extends StatelessWidget {
  final Discussion discussion;
  final bool canJoinDiscussion;
  final VoidCallback onJoinPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onPressed;

  const SingleChatUnjoined({
    @required this.discussion,
    @required this.canJoinDiscussion,
    @required this.onJoinPressed,
    @required this.onDeletePressed,
    @required this.onPressed,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
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
                onTap: this.onPressed,
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
                                        style: TextThemes.moderatorNameChatTab),
                                    TextSpan(
                                        text: Intl.message('invites you to'),
                                        style: TextThemes.inviteTextChatTab),
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
          this.canJoinDiscussion
              ? Container(
                  height: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 87.0,
                        height: 36.0,
                        child: RaisedButton(
                          onPressed: this.onJoinPressed,
                          child: Text(
                            Intl.message('Join'),
                            style: TextThemes.joinButtonTextChatTab,
                          ),
                          color: Color.fromRGBO(247, 247, 255, 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(22.0),
                          ),
                        ),
                      ),
                      // TODO (#10): Reenable the delete key once we have delete on the backend.
                      // SizedBox(width: SpacingValues.small),
                      // Container(
                      //   width: 48.0,
                      //   height: 24.0,
                      //   child: RaisedButton(
                      //     padding: EdgeInsets.all(0.0),
                      //     color: Color.fromRGBO(133, 134, 159, 1.0),
                      //     onPressed: this.onDeletePressed,
                      //     child: Center(
                      //       child: Text(
                      //         Intl.message('Delete'),
                      //         style: TextThemes.deleteButtonTextChatTab,
                      //       ),
                      //     ),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: new BorderRadius.circular(16.0),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
