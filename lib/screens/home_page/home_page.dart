import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/bloc/me/me_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/screens/discussion/screen_args/discussion.dart';
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
  final RouteObserver routeObserver;
  final DiscussionBloc discussionBloc;

  HomePageScreen({
    key: Key,
    @required this.discussionBloc,
    @required this.discussionRepository,
    @required this.routeObserver,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  Color _topBarBackgroundColor;

  String _createDiscussionNonce;
  bool _isCreatingDiscussion;

  HomePageTab _currentTab;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    this._currentTab = HomePageTab.CHAT;

    this._topBarBackgroundColor = Color.fromRGBO(22, 23, 28, 1.0);
    this._createDiscussionNonce = DateTime.now().toString();
    this._isCreatingDiscussion = false;
  }

  @override
  void deactivate() {
    this._createDiscussionNonce = DateTime.now().toString();
    this._isCreatingDiscussion = true;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final windowPadding = MediaQuery.of(context).padding;
    final backgroundColor = Color.fromRGBO(11, 12, 16, 1.0);
    Widget content = BlocBuilder<MeBloc, MeState>(
      builder: (context, meState) {
        final currentUser = MeBloc.extractMe(meState);
        MeBloc.extractMe(BlocProvider.of<MeBloc>(context)?.state);
        return Padding(
          padding: EdgeInsets.only(bottom: windowPadding.bottom),
          child: Column(
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
                  discussionRepository: this.widget.discussionRepository,
                  routeObserver: this.widget.routeObserver,
                ),
              ),
              currentUser == null
                  ? Container(width: 0, height: 0)
                  : BlocListener<DiscussionBloc, DiscussionState>(
                      listener: (context, state) {
                        if (state is DiscussionLoadedState &&
                            this._isCreatingDiscussion) {
                          this._isCreatingDiscussion = false;
                          Navigator.of(context).pushNamed(
                            '/Discussion',
                            arguments: DiscussionArguments(
                              discussionID: state.getDiscussion().id,
                              isStartJoinFlow: false,
                            ),
                          );
                        }
                      },
                      child: HomePageActionBar(
                        currentTab: this._currentTab,
                        backgroundColor: this._topBarBackgroundColor,
                        onNewChatPressed: () {
                          setState(() {
                            this._isCreatingDiscussion = true;
                            this.widget.discussionBloc.add(
                                  NewDiscussionEvent(
                                    title:
                                        "${currentUser.profile.displayName}'s discussion",
                                    anonymityType: AnonymityType.UNKNOWN,
                                    nonce: this._createDiscussionNonce,
                                  ),
                                );
                          });
                        },
                      ),
                    ),
            ],
          ),
        );
      },
    );

    if (this._isCreatingDiscussion) {
      content = AbsorbPointer(
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
  }
}
