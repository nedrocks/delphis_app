import 'package:delphis_app/data/repository/discussion.dart';
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

    Widget notifIcon = SizedBox(
      width: 20,
    );

    if (this.discussion.lockStatus) {
      notifIcon = Icon(
        Icons.lock,
        size: 20,
        color: Colors.white,
      );
    } else if (this.discussion.isMuted) {
      notifIcon = Icon(
        Icons.volume_off,
        size: 20,
        color: Colors.white,
      );
    }

    Widget notificationIcon = SizedBox(
      width: SpacingValues.smallMedium + SpacingValues.extraSmall,
    );

    if (this
        .discussion
        .meViewer
        .lastViewed
        .isBefore(this.discussion.updatedAtAsDateTime())) {
      notificationIcon = Container(
        width: SpacingValues.smallMedium,
        height: SpacingValues.smallMedium,
        margin: EdgeInsets.only(right: SpacingValues.extraSmall),
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: this.onPressed,
        child: Container(
          height: 60.0,
          padding: EdgeInsets.only(
            top: SpacingValues.small,
            bottom: SpacingValues.small,
            right: SpacingValues.medium,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: SpacingValues.small),
              notificationIcon,
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
                moderator: this.discussion.moderator,
                height: 28.0,
                maxNonAnonToShow: 4,
                participants: this.discussion.participants,
              ),
              SizedBox(width: SpacingValues.small),
              ModeratorProfileImage(
                starTopLeftMargin: 21,
                starSize: 12,
                diameter: 32.0,
                profileImageURL:
                    this.discussion.moderator.userProfile.profileImageURL,
              ),
              SizedBox(width: SpacingValues.small),
              notifIcon,
              SizedBox(width: SpacingValues.small),
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
