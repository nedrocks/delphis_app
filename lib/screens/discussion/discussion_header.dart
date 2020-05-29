import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/screens/discussion/header_options_button.dart';
import 'package:delphis_app/widgets/discussion_header/participant_images.dart';
import 'package:delphis_app/widgets/discussion_icon/discussion_icon.dart';
import 'package:delphis_app/widgets/profile_image/moderator_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DiscussionHeader extends StatelessWidget {
  final Discussion discussion;
  final HeaderOptionsCallback onHeaderOptionSelected;

  const DiscussionHeader({
    @required this.discussion,
    @required this.onHeaderOptionSelected,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: HeightValues.appBarHeight,
      padding: EdgeInsets.symmetric(horizontal: SpacingValues.mediumLarge),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Color.fromRGBO(151, 151, 151, 1.0))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                SvgPicture.asset('assets/svg/back_chevron.svg',
                    color: Color.fromRGBO(81, 82, 88, 1.0)),
                SizedBox(width: SpacingValues.small),
              ],
            ),
          ),
          DiscussionIcon(
            height: HeightValues.appBarItemsHeight,
            width: HeightValues.appBarItemsHeight,
            imageURL: this.discussion.iconURL,
          ),
          SizedBox(width: SpacingValues.extraSmall),
          Expanded(
            child: Text(this.discussion.title,
                style: Theme.of(context).textTheme.headline1),
          ),
          Row(
            children: <Widget>[
              ParticipantImages(
                height: HeightValues.appBarItemsHeight,
                participants: this.discussion.participants,
              ),
              SizedBox(width: SpacingValues.small),
              ModeratorProfileImage(
                diameter: HeightValues.appBarItemsHeight,
                profileImageURL:
                    this.discussion.moderator.userProfile.profileImageURL,
              ),
              SizedBox(width: SpacingValues.medium),
              HeaderOptionsButton(
                diameter: HeightValues.appBarItemsHeight,
                onPressed: this.onHeaderOptionSelected,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
