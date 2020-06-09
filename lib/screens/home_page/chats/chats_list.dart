import 'package:delphis_app/bloc/discussion_list/discussion_list_bloc.dart';
import 'package:delphis_app/screens/home_page/chats/single_chat.dart';
import 'package:delphis_app/screens/home_page/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatsList extends StatelessWidget {
  final DiscussionCallback onJoinDiscussionPressed;
  final DiscussionCallback onDeleteDiscussionInvitePressed;
  final DiscussionCallback onDiscussionPressed;
  final RefreshController refreshController;

  ChatsList({
    Key key,
    @required this.refreshController,
    @required this.onJoinDiscussionPressed,
    @required this.onDeleteDiscussionInvitePressed,
    @required this.onDiscussionPressed,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return BlocBuilder<DiscussionListBloc, DiscussionListState>(
        builder: (context, state) {
      if (state is DiscussionListInitial ||
          (state is DiscussionListLoaded && state.isLoading)) {
        if (state is DiscussionListInitial) {
          BlocProvider.of<DiscussionListBloc>(context)
              .add(DiscussionListFetchEvent());
        }
        return Center(child: CircularProgressIndicator());
      } else {
        final discussionList = (state as DiscussionListLoaded).discussionList;
        return SmartRefresher(
          enablePullDown: true,
          header: CustomHeader(
            builder: (context, status) {
              Widget body;
              if (status == RefreshStatus.idle) {
                body = Text(Intl.message("Pull to refresh"));
              } else if (status == RefreshStatus.refreshing) {
                body = CupertinoActivityIndicator();
              } else if (status == RefreshStatus.failed) {
                body = Text(Intl.message("Refresh failed..."));
              } else if (status == RefreshStatus.canRefresh) {
                body = Text("Release to refresh");
              } else {
                body = Container(width: 0, height: 0);
              }
              return Container(
                height: 55.0,
                child: Center(
                  child: body,
                ),
              );
            },
          ),
          controller: this.refreshController,
          onRefresh: () async {
            BlocProvider.of<DiscussionListBloc>(context)
                .add(DiscussionListFetchEvent());
            for (var i = 0; i < 3; i++) {
              await Future.delayed(Duration(milliseconds: 300 * (i + 1)));
              final currState =
                  BlocProvider.of<DiscussionListBloc>(context).state;
              if (currState is DiscussionListLoaded && !currState.isLoading) {
                break;
              }
            }
            this.refreshController.refreshCompleted();
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            key: Key('discussion-list-view'),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: discussionList.length,
            itemBuilder: (context, index) {
              final discussionElem = discussionList.elementAt(index);
              return SingleChat(
                discussion: discussionElem,
                onJoinPressed: () {
                  this.onJoinDiscussionPressed(discussionElem);
                },
                onDeletePressed: () {
                  this.onDeleteDiscussionInvitePressed(discussionElem);
                },
                onPressed: () {
                  this.onDiscussionPressed(discussionElem);
                },
              );
            },
          ),
        );
      }
    });
  }
}
