import 'package:delphis_app/data/repository/twitter_user.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/widgets/profile_image/profile_image.dart';
import 'package:delphis_app/widgets/verified_checkmark/verified_checkmark.dart';
import 'package:flutter/material.dart';

class TwitterUserSearchListEntry extends StatelessWidget {
  final TwitterUserInfo userInfo;
  final VoidCallback onTap;
  final bool isChecked;
  final bool isSelected;

  TwitterUserSearchListEntry(
      {@required this.userInfo,
      this.onTap,
      this.isChecked = true,
      this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    final iconSize = 32.0;
    final verifiedMarkSize = 16.0;
    final checkMarkSize = 22.0;
    Widget profileImage = Container(
      height: iconSize + verifiedMarkSize / 2.5,
      width: iconSize + verifiedMarkSize / 3,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: ProfileImage(
              height: iconSize,
              width: iconSize,
              profileImageURL: this.userInfo.profileImageURL,
              isAnonymous: false,
            ),
          ),
          !userInfo.verified
              ? Container()
              : Positioned(
                  bottom: 0,
                  right: 0,
                  child: VerifiedCheckmark(
                    height: verifiedMarkSize,
                    width: verifiedMarkSize,
                  ),
                )
        ],
      ),
    );

    Widget checkMark = Container(
      margin: EdgeInsets.only(left: 2, right: 2),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: Colors.white)),
      width: checkMarkSize - 4,
      height: checkMarkSize - 4,
    );
    if (isChecked) {
      checkMark =
          Icon(Icons.check_circle, color: Colors.grey, size: checkMarkSize);
    } else if (isSelected) {
      checkMark =
          Icon(Icons.check_circle, color: Colors.white, size: checkMarkSize);
    }
    return Container(
      margin: EdgeInsets.only(bottom: SpacingValues.small),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SpacingValues.medium)),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Container(
                child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: this.isChecked
                    ? null
                    : () {
                        if (this.onTap != null) this.onTap();
                        return true;
                      },
                child: Container(
                  height: iconSize,
                  margin: EdgeInsets.all(SpacingValues.small),
                  child: Row(
                    children: [
                      checkMark,
                      SizedBox(width: SpacingValues.small),
                      profileImage,
                      SizedBox(width: SpacingValues.small),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${userInfo.displayName}",
                              style: TextThemes.goIncognitoOptionName,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: SpacingValues.xxSmall),
                            Text(
                              "@${userInfo.name}",
                              style: TextThemes.goIncognitoOptionAction,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
