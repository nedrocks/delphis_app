import 'package:delphis_app/data/repository/discussion_access.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccessRequestEntry extends StatelessWidget {
  final DiscussionAccessRequest accessRequest;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const AccessRequestEntry({
    Key key,
    @required this.accessRequest,
    @required this.onAccept,
    @required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Colors.transparent;
    var statusMessageText = "";

    /* Format right messages and colors */
    if (accessRequest.status == InviteRequestStatus.REJECTED) {
      statusMessageText = Intl.message("You rejected this request");
      backgroundColor = Colors.red[300];
    } else if (accessRequest.status == InviteRequestStatus.ACCEPTED) {
      statusMessageText = Intl.message("You approved this request");
      backgroundColor = Colors.green[300];
    } else if (accessRequest.status == InviteRequestStatus.CANCELLED) {
      statusMessageText = Intl.message("This request has been cancelled.");
      backgroundColor = Colors.yellow[300];
    }

    /* Block sliders */
    bool hasActions = true;
    if (accessRequest.isLoadingLocally ||
        accessRequest.status != InviteRequestStatus.PENDING) {
      hasActions = false;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(22, 23, 28, 1.0),
            width: 1.0,
          ),
        ),
      ),
      child: Container(
        color: backgroundColor,
        height: 70,
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                horizontal: SpacingValues.large,
                vertical: SpacingValues.small,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.6,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(
                              accessRequest.userProfile.profileImageURL,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: SpacingValues.medium,
                        ),
                        Flexible(
                          child: Text(
                            accessRequest.userProfile.displayName,
                            style: TextThemes.onboardBody,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: SpacingValues.small,
                  ),
                  Flexible(
                    flex: 1,
                    child: hasActions
                        ? Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Pressable(
                                  width: 50,
                                  height: 50,
                                  onPressed: this.onReject,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    padding:
                                        EdgeInsets.all(SpacingValues.small),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Pressable(
                                  width: 50,
                                  height: 50,
                                  onPressed: this.onAccept,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    padding:
                                        EdgeInsets.all(SpacingValues.small),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Text(
                            statusMessageText,
                            style: TextThemes.discussionPostAuthorAnon,
                          ),
                  ),
                ],
              ),
            ),
            !accessRequest.isLoadingLocally
                ? Container()
                : Positioned.fill(
                    child: Container(
                      color: Colors.grey.withOpacity(0.2),
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
