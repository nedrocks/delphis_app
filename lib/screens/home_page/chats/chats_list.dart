import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/bloc/discussion_list/discussion_list_bloc.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/screens/home_page/chats/single_chat.dart';
import 'package:delphis_app/screens/home_page/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatsList extends StatelessWidget {
  final Duration durationBeforeAutoRefresh;
  final DiscussionCallback onJoinDiscussionPressed;
  final DiscussionCallback onDeleteDiscussionInvitePressed;
  final DiscussionCallback onDiscussionPressed;
  final RefreshController refreshController;
  final User currentUser;

  ChatsList({
    Key key,
    @required this.refreshController,
    @required this.onJoinDiscussionPressed,
    @required this.onDeleteDiscussionInvitePressed,
    @required this.onDiscussionPressed,
    @required this.currentUser,
    this.durationBeforeAutoRefresh,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return BlocListener<DiscussionListBloc, DiscussionListState>(
      listenWhen: (prev, next) {
        return prev is DiscussionListLoading &&
            (next is DiscussionListLoaded || next is DiscussionListError);
      },
      listener: (context, state) {
        this.refreshController.refreshCompleted();
      },
      child: BlocBuilder<DiscussionListBloc, DiscussionListState>(
          builder: (context, state) {
        if (state is DiscussionListInitial) {
          BlocProvider.of<DiscussionListBloc>(context)
              .add(DiscussionListFetchEvent());
          return Container();
        }

        if (state is DiscussionListLoading &&
            state.discussionList.length == 0) {
          return Center(child: CircularProgressIndicator());
        }

        var errorWidget = Container();
        if (state is DiscussionListError) {
          errorWidget = Container(
            color: Colors.red,
            padding: EdgeInsets.symmetric(
                vertical: SpacingValues.medium,
                horizontal: SpacingValues.large),
            child: Text(
              state.error.toString(),
              textAlign: TextAlign.center,
            ),
          );
        }

        /* Autorefresh if discussion list is outdated */
        var duration = this.durationBeforeAutoRefresh ?? Duration(minutes: 20);
        if (state is DiscussionListHasTimestamp &&
            DateTime.now().difference(state.timestamp) > duration) {
          BlocProvider.of<DiscussionListBloc>(context)
              .add(DiscussionListFetchEvent());
        }

        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: CustomHeader(
            builder: (context, status) {
              Widget body;
              if (status == RefreshStatus.idle) {
                body = CupertinoActivityIndicator();
              } else if (status == RefreshStatus.refreshing) {
                body = CupertinoActivityIndicator();
              } else if (status == RefreshStatus.failed) {
                body = Text(Intl.message("Refresh failed..."));
              } else if (status == RefreshStatus.canRefresh) {
                body = CupertinoActivityIndicator();
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
          footer: Container(),
          controller: this.refreshController,
          onRefresh: () async {
            BlocProvider.of<DiscussionListBloc>(context)
                .add(DiscussionListFetchEvent());
          },
          onLoading: () {},
          child: ListView.builder(
            padding: EdgeInsets.zero,
            key: Key('discussion-list-view'),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: state.discussionList.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return errorWidget;
              index--;
              var discussionElem = state.discussionList[index];
              return BlocBuilder<DiscussionBloc, DiscussionState>(
                builder: (context, discussionState) {
                  if (discussionState is DiscussionLoadedState &&
                      discussionState.getDiscussion() != null) {
                    if (discussionState.getDiscussion().id ==
                        discussionElem.id) {
                      state.discussionList[index] =
                          discussionState.getDiscussion();
                      discussionElem = state.discussionList[index];
                    }
                  }
                  return SingleChat(
                    discussion: discussionElem,
                    canJoinDiscussions: currentUser?.isTwitterAuth ?? false,
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
              );
            },
          ),
        );
      }),
    );
  }
}
