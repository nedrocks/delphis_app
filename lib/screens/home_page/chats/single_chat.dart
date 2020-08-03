import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/screens/home_page/chats/single_chat_joined.dart';
import 'package:delphis_app/screens/home_page/chats/single_chat_unjoined.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SingleChat extends StatelessWidget {
  final Discussion discussion;
  final bool canJoinDiscussions;
  final VoidCallback onDeletePressed;
  final VoidCallback onJoinPressed;
  final VoidCallback onPressed;
  final VoidCallback onArchivePressed;
  final VoidCallback onMutePressed;
  final SlidableController slidableController;

  const SingleChat({
    @required this.discussion,
    @required this.onDeletePressed,
    @required this.onJoinPressed,
    @required this.onPressed,
    @required this.canJoinDiscussions,
    @required this.onArchivePressed,
    @required this.onMutePressed,
    this.slidableController,
  }) : super();

  @override
  Widget build(BuildContext context) {
    Widget contents;
    if (this.discussion.meParticipant != null &&
        this.discussion.meParticipant.hasJoined) {
      contents = SingleChatJoined(
          discussion: this.discussion,
          onPressed: this.onPressed,
          notificationCount: 0);
    } else if (this.discussion.meParticipant == null ||
        !this.discussion.meParticipant.hasJoined) {
      // I have not joined this chat.
      contents = SingleChatUnjoined(
        canJoinDiscussion: this.canJoinDiscussions,
        discussion: this.discussion,
        onDeletePressed: this.onDeletePressed,
        onJoinPressed: this.onJoinPressed,
        onPressed: this.onPressed,
      );
    }

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      controller: this.slidableController,
      closeOnScroll: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom:
                BorderSide(color: Color.fromRGBO(22, 23, 28, 1.0), width: 1.0),
          ),
        ),
        child: contents,
      ),
      actions: <Widget>[],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: ChathamColors.deleteChatSlideButtonColor,
          icon: Icons.delete,
          onTap: this.onDeletePressed,
        ),
        IconSlideAction(
          caption: 'Mute',
          color: ChathamColors.muteChatSlideButtonColor,
          icon: Icons.volume_off,
          onTap: this.onMutePressed,
        ),
        IconSlideAction(
          caption: 'Archive',
          icon: Icons.archive,
          color: ChathamColors.archiveChatSlideButtonColor,
          onTap: this.onArchivePressed,
        ),
      ],
    );
  }
}
