import 'package:delphis_app/data/repository/discussion_access.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
        actions: hasActions
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
          color: Colors.blue,
          height: 70,
        ),
      ),
    );
  }
}
