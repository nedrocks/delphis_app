import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/bloc/me/me_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/screens/discussion/screen_args/discussion.dart';
import 'package:delphis_app/screens/home_page/chats/chats_screen.dart';
import 'package:delphis_app/screens/home_page/home_page_topbar.dart';
import 'package:delphis_app/screens/upsert_discussion/screen_arguments.dart';
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
  final RouteObserver routeObserver;

  HomePageScreen({
    key: Key,
    @required this.discussionRepository,
    @required this.routeObserver,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  HomePageTab _currentTab;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this._currentTab = HomePageTab.CHAT;
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final windowPadding = MediaQuery.of(context).padding;
    final backgroundColor = Color.fromRGBO(11, 12, 16, 1.0);
    Widget content = BlocBuilder<MeBloc, MeState>(
      builder: (context, meState) {
        final currentUser = MeBloc.extractMe(meState);
        return Padding(
          padding: EdgeInsets.only(bottom: windowPadding.bottom),
          child: Column(
            children: [
              Container(
                  height: windowPadding.top,
                  color: ChathamColors.topBarBackgroundColor),
              HomePageTopBar(
                  height: 80.0,
                  title: Intl.message('Chats'),
                  backgroundColor: ChathamColors.topBarBackgroundColor),
              Expanded(
                child: ChatsScreen(
                  discussionRepository: this.widget.discussionRepository,
                  routeObserver: this.widget.routeObserver,
                  currentUser: currentUser,
                ),
              ),
              currentUser == null || !currentUser.isTwitterAuth
                  ? Container(width: 0, height: 0)
                  : HomePageActionBar(
                      currentTab: this._currentTab,
                      backgroundColor: ChathamColors.topBarBackgroundColor,
                      onNewChatPressed: () {
                        Navigator.pushNamed(context, '/Discussion/Upsert',
                            arguments: UpsertDiscussionArguments());
                      },
                    ),
            ],
          ),
        );
      },
    );

    return BlocListener<DiscussionBloc, DiscussionState>(
        listenWhen: (prev, next) {
      return prev is AddingDiscussionState &&
          next is DiscussionLoadedState &&
          !next.isLoading;
    }, listener: (context, state) {
      if (state is DiscussionLoadedState && !state.isLoading) {
        Navigator.of(context).pushNamed(
          '/Discussion',
          arguments: DiscussionArguments(
            discussionID: state.getDiscussion().id,
            isStartJoinFlow: false,
          ),
        );
      }
    }, child: BlocBuilder<DiscussionBloc, DiscussionState>(
      builder: (context, state) {
        if (state is AddingDiscussionState) {
          return AbsorbPointer(
            absorbing: true,
            child: Stack(
              children: [
                Opacity(opacity: 0.4, child: content),
                Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        }
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: backgroundColor,
          body: content,
        );
      },
    ));
  }
}
