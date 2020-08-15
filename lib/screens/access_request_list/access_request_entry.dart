import 'package:delphis_app/data/repository/discussion_access.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class AccessRequestEntry extends StatelessWidget {
  final SlidableController slidableController;
  final DiscussionAccessRequest accessRequest;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const AccessRequestEntry({
    Key key,
    this.slidableController,
    @required this.accessRequest,
    @required this.onAccept,
    @required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Colors.transparent;
    var requestDate = DateTime.parse(accessRequest.updatedAt);
    var dateFormat = DateFormat(DateFormat.YEAR_MONTH_DAY);
    var timeFormat = DateFormat(DateFormat.HOUR_MINUTE);
    var requestDateText = Intl.message(
        "Requested access on ${dateFormat.format(requestDate)} at ${timeFormat.format(requestDate)}");

    /* Format right messages and colors */
    if (accessRequest.status == InviteRequestStatus.REJECTED) {
      requestDateText = Intl.message("You rejected this request");
      backgroundColor = Colors.red[300];
    } else if (accessRequest.status == InviteRequestStatus.ACCEPTED) {
      requestDateText = Intl.message("You approved this request");
      backgroundColor = Colors.green[300];
    } else if (accessRequest.status == InviteRequestStatus.REJECTED) {
      requestDateText = Intl.message("You rejected this request");
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
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        controller: this.slidableController ?? SlidableController(),
        closeOnScroll: true,
        actions: !hasActions
            ? []
            : [
                IconSlideAction(
                  caption: 'Reject',
                  color: Colors.red,
                  icon: Icons.block,
                  onTap: this.onReject,
                ),
              ],
        secondaryActions: !hasActions
            ? []
            : [
                IconSlideAction(
                  caption: 'Accept',
                  color: Colors.green,
                  icon: Icons.check,
                  onTap: this.onAccept,
                ),
              ],
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
                      width: SpacingValues.medium,
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        requestDateText,
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
      ),
    );
  }
}
