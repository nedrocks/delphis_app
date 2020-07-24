import 'package:delphis_app/data/repository/twitter_user.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/widgets/profile_image/profile_image.dart';
import 'package:delphis_app/widgets/verified_checkmark/verified_checkmark.dart';
import 'package:flutter/material.dart';

class TwitterUserEntryWidget extends StatelessWidget {
  final TwitterUserInfo userInfo;
  final VoidCallback onTap;

  TwitterUserEntryWidget({
    @required this.userInfo,
    this.onTap
  });
  
  @override
  Widget build(BuildContext context) {
    final iconSize = 40.0;
    final verifiedMarkSize = 16.0;
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
          !userInfo.isVerified ? Container() : Positioned(
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if(this.onTap != null)
            this.onTap();
          return true;
        },
        child: Container(
          height: iconSize,
          margin: EdgeInsets.only(
            bottom: SpacingValues.small,
            left: SpacingValues.medium,
            right: SpacingValues.medium
          ),
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              profileImage,
              SizedBox(width: SpacingValues.small),
              Text(userInfo.displayName)
              // TODO: format and show nickname too
            ],
          ),
        ),
      ),
    );
  }
}