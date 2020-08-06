import 'package:delphis_app/data/repository/discussion_invite.dart';
import 'package:delphis_app/screens/discussion/screen_args/discussion.dart';
import 'package:delphis_app/screens/home_page/chats/single_chat_unjoined.dart';
import 'package:flutter/material.dart';

class InviteEntry extends StatelessWidget {
  final DiscussionInvite invite;

  const InviteEntry({
    Key key,
    @required this.invite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom:
                BorderSide(color: Color.fromRGBO(22, 23, 28, 1.0), width: 1.0),
          ),
        ),
        child: SingleChatUnjoined(
          discussion: invite.discussion,
          canJoinDiscussion: true,
          onJoinPressed: () {
            Navigator.of(context).pushNamed(
              '/Discussion',
              arguments:
                  DiscussionArguments(discussionID: invite.discussion.id),
            );
          },
          onDeletePressed: () {
            // TODO: Put it in delete tab. Also handle archive case
          },
          onPressed: null,
        ),
      ),
    );
  }
}
