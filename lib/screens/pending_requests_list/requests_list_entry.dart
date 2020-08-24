import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/data/repository/discussion_access.dart';
import 'package:delphis_app/screens/discussion/screen_args/discussion.dart';
import 'package:delphis_app/screens/home_page/chats/single_chat_joined.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestsListEntry extends StatelessWidget {
  final DiscussionAccessRequest request;

  const RequestsListEntry({
    Key key,
    @required this.request,
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
        child: SingleChatJoined(
          discussion: request.discussion,
          onPressed: () {
            BlocProvider.of<DiscussionBloc>(context).add(DiscussionQueryEvent(
                discussionID: request.discussion.id, nonce: DateTime.now()));
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/Discussion',
              ModalRoute.withName("/Home"),
              arguments:
                  DiscussionArguments(discussionID: request.discussion.id),
            );
          },
          notificationCount: 0,
        ),
      ),
    );
  }
}
