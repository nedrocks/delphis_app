import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/widgets/discussion_header/participant_images.dart';
import 'package:delphis_app/widgets/discussion_icon/discussion_icon.dart';
import 'package:delphis_app/widgets/notification_badge/notification_badge.dart';
import 'package:delphis_app/widgets/profile_image/moderator_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SingleChatJoined extends StatelessWidget {
  final Discussion discussion;
  final int notificationCount;
  final VoidCallback onPressed;

  const SingleChatJoined({
    @required this.discussion,
    @required this.notificationCount,
    @required this.onPressed,
  }) : super();

  @override
  Widget build(BuildContext context) {
    Widget discussionIcon = DiscussionIcon(
        width: 28, height: 28, imageURL: this.discussion.iconURL);
    if (this.notificationCount > 0) {
      discussionIcon = Container(
        width: 34,
        height: 34,
        alignment: Alignment.bottomLeft,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            discussionIcon,
            Align(
              alignment: Alignment(1.0, -1.0),
              child: NotificationBadge(
                diameter: 18.0,
                notificationCount: this.notificationCount,
                backgroundColor: Colors.black,
              ),
            ),
          ],
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: this.onPressed,
        child: Container(
          height: 60.0,
          padding: EdgeInsets.symmetric(
            vertical: SpacingValues.small,
            horizontal: SpacingValues.medium,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              discussionIcon,
              SizedBox(width: SpacingValues.small),
              Expanded(
                child: Text(
                  this.discussion.title,
                  style: TextThemes.discussionTitleChatTab,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ParticipantImages(
                height: 28.0,
                maxNonAnonToShow: 4,
                participants: this.discussion.participants,
              ),
              SizedBox(width: SpacingValues.small),
              ModeratorProfileImage(
                starTopLeftMargin: 21.5,
                starSize: 12,
                diameter: 32.0,
                profileImageURL:
                    this.discussion.moderator.userProfile.profileImageURL,
              ),
              SizedBox(width: SpacingValues.medium),
              SvgPicture.asset(
                'assets/svg/forward_chevron.svg',
                color: Color.fromRGBO(81, 82, 88, 1.0),
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
