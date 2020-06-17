import 'dart:math';

import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'discussion_announcement_post.dart';
import 'discussion_post.dart';

class DiscussionPostListView extends StatelessWidget {
  final ScrollController scrollController;
  final Discussion discussion;
  final bool isVisible;

  final RefreshController refreshController;
  final bool isRefreshEnabled;

  DiscussionPostListView({
    @required key,
    @required this.scrollController,
    @required this.discussion,
    @required this.refreshController,
    @required this.isRefreshEnabled,
    this.isVisible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Color.fromRGBO(151, 151, 151, 0.4))),
      ),
      child: SmartRefresher(
        enablePullDown: this.isRefreshEnabled,
        enablePullUp: true,
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
            // Rotate is used here because the widget is displayed upside
            // down.
            return Transform.rotate(
              angle: pi,
              child: Container(
                height: 55.0,
                child: Center(
                  child: body,
                ),
              ),
            );
          },
        ),
        controller: this.refreshController,
        onRefresh: () async {
          final discussionBloc = BlocProvider.of<DiscussionBloc>(context);
          discussionBloc
              .add(RefreshPostsEvent(discussionID: this.discussion.id));
          for (var i = 0; i < 3; i++) {
            await Future.delayed(Duration(milliseconds: 300 * (i + 1)));
            final currState = discussionBloc.state;
            if (currState is DiscussionLoadedState) {
              break;
            }
          }
          this.refreshController.refreshCompleted();
        },
        onLoading: () async {
          final discussionBloc = BlocProvider.of<DiscussionBloc>(context);
          var currState = discussionBloc.state;
          if(currState is DiscussionLoadedState) {
            if(!currState.getDiscussion().postsConnection.pageInfo.hasNextPage) {
              await Future.delayed(Duration(milliseconds: 500));
              this.refreshController.loadComplete();
              return;
            }
          }
          discussionBloc
              .add(LoadNextPostsPageEvent(discussionID: this.discussion.id));
          for (var i = 0; i < 3; i++) {
            await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
            currState = discussionBloc.state;
            if (currState is DiscussionLoadedState && !currState.isLoading) {
              this.refreshController.loadComplete();
              return;
            }
          }
          this.refreshController.loadFailed();
        },
        child: ListView.builder(
          key: Key('discussion-posts-' + this.discussion.id),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: (this.discussion.posts ?? []).length,
          controller: this.scrollController,
          reverse: true,
          itemBuilder: (context, index) {
            final post = DiscussionPost(
              post: this.discussion.posts[index],
              moderator: this.discussion.moderator,
              participant: this.discussion.getParticipantForPostIdx(index),
            );
            if (true) {
              return post;
            } else {
              // TODO: This should be hooked up to announcement posts.
              return DiscussionAnnouncementPost(post: post);
            }
          },
        ),
      ),
    );
  }
}
