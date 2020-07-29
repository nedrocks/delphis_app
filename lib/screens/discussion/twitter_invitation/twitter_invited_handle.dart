import 'package:delphis_app/data/repository/twitter_user.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';

class TwitterInvitedHandle extends StatelessWidget {
  final double deleteIconSize;
  final TwitterUserInfo user;
  final VoidCallback onDeletePressed;

  const TwitterInvitedHandle(
      {Key key, @required this.user, this.onDeletePressed, this.deleteIconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(100.0),
      clipBehavior: Clip.antiAlias,
      child: Container(
          padding: EdgeInsets.all(SpacingValues.xxSmall),
          child: InkWell(
            onTap: this.onDeletePressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: this.deleteIconSize ?? 18,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: SpacingValues.extraSmall,
                      top: SpacingValues.xxSmall,
                      right: SpacingValues.extraSmall),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(100.0)),
                  child: Text(
                    user.name,
                    style: TextThemes.goIncognitoOptionAction,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
