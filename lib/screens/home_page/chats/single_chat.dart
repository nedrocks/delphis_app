import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/notifiers/home_page_tab.dart';
import 'package:delphis_app/screens/home_page/chats/single_chat_joined.dart';
import 'package:delphis_app/screens/home_page/chats/single_chat_unjoined.dart';
import 'package:delphis_app/screens/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class SingleChat extends StatelessWidget {
  final Discussion discussion;
  final bool canJoinDiscussions;
  final VoidCallback onDeletePressed;
  final VoidCallback onJoinPressed;
  final VoidCallback onPressed;
  final VoidCallback onArchivePressed;
  final VoidCallback onMutePressed;
  final VoidCallback onUnMutePressed;
  final VoidCallback onActivatePressed;
  final SlidableController slidableController;

  const SingleChat({
    @required this.discussion,
    @required this.onDeletePressed,
    @required this.onJoinPressed,
    @required this.onPressed,
    @required this.canJoinDiscussions,
    @required this.onArchivePressed,
    @required this.onMutePressed,
    @required this.onUnMutePressed,
    @required this.onActivatePressed,
    this.slidableController,
  }) : super();

  @override
  Widget build(BuildContext context) {
    Widget contents;
    if (!this.discussion.isPendingAccess) {
      contents = SingleChatJoined(
        discussion: this.discussion,
        onPressed: this.onPressed,
        notificationCount: 0,
      );
    } else {
      contents = SingleChatUnjoined(
        canJoinDiscussion: this.canJoinDiscussions,
        discussion: this.discussion,
        onDeletePressed: this.onDeletePressed,
        onJoinPressed: this.onJoinPressed,
        onPressed: this.onPressed,
      );
    }

    return Consumer<HomePageTabNotifier>(
      child: contents,
      builder: (context, currentTab, child) {
        bool isHidden = false;
        List<Widget> actions = [];
        switch (currentTab.value) {
          case HomePageTab.ARCHIVED:
            isHidden = this.discussion.isDeletedLocally ||
                this.discussion.isActivatedLocally;
            actions = [
              IconSlideAction(
                caption: 'Delete',
                color: ChathamColors.deleteChatSlideButtonColor,
                icon: Icons.delete,
                onTap: this.onDeletePressed,
              ),
              IconSlideAction(
                caption: 'Restore',
                icon: Icons.restore,
                color: ChathamColors.archiveChatSlideButtonColor,
                onTap: this.onActivatePressed,
              ),
            ];
            break;
          case HomePageTab.ACTIVE:
            isHidden = this.discussion.isDeletedLocally ||
                this.discussion.isArchivedLocally;
            actions = [
              IconSlideAction(
                caption: 'Delete',
                color: ChathamColors.deleteChatSlideButtonColor,
                icon: Icons.delete,
                onTap: this.onDeletePressed,
              ),
              IconSlideAction(
                caption: this.discussion.isMuted ? 'Unmute' : 'Mute',
                color: ChathamColors.muteChatSlideButtonColor,
                icon: this.discussion.isMuted
                    ? Icons.volume_up
                    : Icons.volume_off,
                onTap: this.discussion.isMuted
                    ? this.onUnMutePressed
                    : this.onMutePressed,
              ),
              IconSlideAction(
                caption: 'Archive',
                icon: Icons.archive,
                color: ChathamColors.archiveChatSlideButtonColor,
                onTap: this.onArchivePressed,
              ),
            ];
            break;
          case HomePageTab.TRASHED:
            isHidden = this.discussion.isActivatedLocally;
            actions = [
              IconSlideAction(
                caption: 'Restore',
                icon: Icons.restore,
                color: ChathamColors.archiveChatSlideButtonColor,
                onTap: this.onActivatePressed,
              ),
            ];
            break;
        }

        return Container(
          height: isHidden ? 0 : null,
          child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.15,
            controller: this.slidableController,
            closeOnScroll: true,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Color.fromRGBO(22, 23, 28, 1.0), width: 1.0),
                ),
              ),
              child: child,
            ),
            actions: <Widget>[],
            secondaryActions: actions,
          ),
        );
      },
    );
  }
}
