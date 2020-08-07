import 'package:delphis_app/data/repository/moderator.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/widgets/profile_image/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ModeratorSnippet extends StatelessWidget {
  final Moderator moderator;
  final VoidCallback onTap;

  ModeratorSnippet({@required this.moderator, this.onTap});

  @override
  Widget build(BuildContext context) {
    double diameter = 42;
    var outerBorderWidth = 1.5;
    var profileImage = ProfileImage(
      width: diameter - outerBorderWidth,
      height: diameter - outerBorderWidth,
      profileImageURL: this.moderator.userProfile.profileImageURL,
      isAnonymous: false,
      gradient: ChathamColors.whiteGradient,
      gradientWidth: outerBorderWidth,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: this.onTap,
        child: Container(
          padding: EdgeInsets.all(SpacingValues.small),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              profileImage,
              SizedBox(width: SpacingValues.medium),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      moderator.userProfile.displayName,
                      style:
                          TextThemes.onboardBody.copyWith(color: Colors.blue),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: SpacingValues.xxSmall),
                    Text(
                      Intl.message("Is moderating this chat"),
                      style: TextThemes.discussionJoinModeratorInfo,
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
