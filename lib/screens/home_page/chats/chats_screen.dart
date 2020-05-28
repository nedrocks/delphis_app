import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/moderator.dart';
import 'package:delphis_app/data/repository/user_profile.dart';
import 'package:delphis_app/screens/home_page/chats/single_chat.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen() : super();

  @override
  State<StatefulWidget> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  List<Discussion> discussions;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final userProfile = UserProfile(
        displayName: "Ned Rockson",
        profileImageURL:
            'https://pbs.twimg.com/profile_images/569623151382765568/IXqTQzHo_normal.jpeg');
    final moderator = Moderator(
      id: 'moderator-1',
      discussion: null,
      userProfile: userProfile,
    );
    var discussionObj = Discussion(
        id: '12345',
        moderator: moderator,
        meParticipant: null,
        title: 'Blue Ridge Ventures');

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black,
        body: ListView(children: [
          SingleChat(
            discussion: discussionObj,
            onJoinPressed: () {
              print('on pressed');
            },
            onDeletePressed: () {
              print('on delete');
            },
            onPressed: () {
              print('onPressed');
            },
          )
        ]),
      ),
    );
  }
}
