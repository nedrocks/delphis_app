import 'package:delphis_app/bloc/discussion_list/discussion_list_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/screens/home_page/chats/chats_list.dart';
import 'package:delphis_app/screens/home_page/chats/chats_screen.dart';
import 'package:delphis_app/screens/home_page/home_page_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'dart:ui';

import 'home_page_action_bar.dart';

typedef void DiscussionCallback(Discussion discussion);

enum HomePageTab {
  MENTION,
  CHAT,
}

class HomePageScreen extends StatefulWidget {
  final DiscussionRepository discussionRepository;

  const HomePageScreen({
    @required this.discussionRepository,
  }) : super();

  @override
  State<StatefulWidget> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  DiscussionListBloc _discussionListBloc;
  Color _topBarBackgroundColor;

  HomePageTab _currentTab;

  @override
  void dispose() {
    this._discussionListBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    this._currentTab = HomePageTab.CHAT;

    this._topBarBackgroundColor = Color.fromRGBO(22, 23, 28, 1.0);
    this._discussionListBloc =
        DiscussionListBloc(repository: this.widget.discussionRepository);
  }

  @override
  Widget build(BuildContext context) {
    final windowPadding = MediaQuery.of(context).padding;
    final backgroundColor = Color.fromRGBO(11, 12, 16, 1.0);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      body: BlocProvider<DiscussionListBloc>.value(
        value: this._discussionListBloc,
        child: Padding(
          padding: EdgeInsets.only(bottom: windowPadding.bottom),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  Container(
                      height: windowPadding.top,
                      color: this._topBarBackgroundColor),
                  HomePageTopBar(
                      height: 80.0,
                      title: Intl.message('Chats'),
                      backgroundColor: this._topBarBackgroundColor),
                  Expanded(
                    child: ChatsScreen(
                        discussionRepository: this.widget.discussionRepository),
                  ),
                ],
              ),
              HomePageActionBar(
                currentTab: this._currentTab,
                backgroundColor: this._topBarBackgroundColor,
                onNewChatPressed: () {
                  // TODO: Start a new chat!
                  print('This starts a new chat!');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
