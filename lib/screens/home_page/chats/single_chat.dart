import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/screens/home_page/chats/single_chat_joined.dart';
import 'package:delphis_app/screens/home_page/chats/single_chat_unjoined.dart';
import 'package:flutter/material.dart';

class SingleChat extends StatelessWidget {
  final Discussion discussion;
  final VoidCallback onDeletePressed;
  final VoidCallback onJoinPressed;
  final VoidCallback onPressed;

  const SingleChat({
    @required this.discussion,
    @required this.onDeletePressed,
    @required this.onJoinPressed,
    @required this.onPressed,
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
        discussion: this.discussion,
        onDeletePressed: this.onDeletePressed,
        onJoinPressed: this.onJoinPressed,
        onPressed: this.onPressed,
      );
    }
    return DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom:
                BorderSide(color: Color.fromRGBO(22, 23, 28, 1.0), width: 1.0),
          ),
        ),
        child: contents);
  }
}
