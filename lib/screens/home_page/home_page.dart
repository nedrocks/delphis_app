import 'package:delphis_app/bloc/auth/auth_bloc.dart';
import 'package:delphis_app/bloc/me/me_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/notifiers/home_page_tab.dart';
import 'package:delphis_app/screens/discussion/header_options_button.dart';
import 'package:delphis_app/screens/home_page/chats/chats_screen.dart';
import 'package:delphis_app/screens/home_page/home_page_topbar.dart';
import 'package:delphis_app/screens/upsert_discussion/screen_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'dart:ui';

import 'home_page_action_bar.dart';

typedef void DiscussionCallback(Discussion discussion);
typedef void HomePageChatTabCallback(HomePageTab tab);

enum HomePageTab {
  ARCHIVED,
  ACTIVE,
  TRASHED,
}

class HomePageScreen extends StatelessWidget {
  final DiscussionRepository discussionRepository;
  final RouteObserver routeObserver;

  HomePageScreen({
    key: Key,
    @required this.discussionRepository,
    @required this.routeObserver,
  }) : super(key: key);

  String _getTitle(HomePageTab currentTab) {
    switch (currentTab) {
      case HomePageTab.ACTIVE:
        return 'Active Chats';
      case HomePageTab.ARCHIVED:
        return 'Archived Chats';
      case HomePageTab.TRASHED:
        return 'Deleted Chats';
    }
    return "";
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
              Consumer<HomePageTabNotifier>(
                builder: (context, currentTab, child) {
                  return HomePageTopBar(
                    height: 80.0,
                    title: Intl.message(
                      this._getTitle(currentTab.value),
                    ),
                    backgroundColor: ChathamColors.topBarBackgroundColor,
                  );
                },
              ),
              Expanded(
                child: ChatsScreen(
                  discussionRepository: this.discussionRepository,
                  routeObserver: this.routeObserver,
                  currentUser: currentUser,
                ),
              ),
              currentUser == null || !currentUser.isTwitterAuth
                  ? Container(width: 0, height: 0)
                  : Consumer<HomePageTabNotifier>(
                      builder: (context, currentTab, child) {
                        return HomePageActionBar(
                          currentTab: currentTab.value,
                          backgroundColor: ChathamColors.topBarBackgroundColor,
                          onNewChatPressed: () {
                            Navigator.pushNamed(context, '/Discussion/Upsert',
                                arguments: UpsertDiscussionArguments());
                          },
                          onTabPressed: (HomePageTab tab) {
                            Provider.of<HomePageTabNotifier>(
                              context,
                              listen: false,
                            ).value = tab;
                          },
                          onOptionSelected: (HeaderOption option) {
                            switch (option) {
                              case HeaderOption.logout:
                                BlocProvider.of<AuthBloc>(context)
                                    .add(LogoutAuthEvent());
                                break;
                              default:
                                break;
                            }
                          },
                        );
                      },
                    ),
            ],
          ),
        );
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      body: content,
    );
  }
}
