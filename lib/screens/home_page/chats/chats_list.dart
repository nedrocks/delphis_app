import 'package:delphis_app/bloc/discussion_list/discussion_list_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/notifiers/home_page_tab.dart';
import 'package:delphis_app/screens/discussion_join/button.dart';
import 'package:delphis_app/screens/home_page/chats/single_chat.dart';
import 'package:delphis_app/screens/home_page/home_page.dart';
import 'package:delphis_app/screens/home_page/home_page_pending_requests_button.dart';
import 'package:delphis_app/widgets/animated_size_container/animated_size_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatsList extends StatelessWidget {
  final Duration durationBeforeAutoRefresh;
  final DiscussionCallback onJoinDiscussionPressed;
  final DiscussionCallback onDeleteDiscussionPressed;
  final DiscussionCallback onArchiveDiscussionPressed;
  final DiscussionCallback onActivateDiscussionPressed;
  final DiscussionCallback onMuteDiscussionPressed;
  final DiscussionCallback onUnMuteDiscussionPressed;
  final DiscussionCallback onDiscussionPressed;
  final RefreshController refreshController;
  final User currentUser;
  final SlidableController slidableController;

  ChatsList({
    Key key,
    @required this.refreshController,
    @required this.onJoinDiscussionPressed,
    @required this.onDeleteDiscussionPressed,
    @required this.onArchiveDiscussionPressed,
    @required this.onActivateDiscussionPressed,
    @required this.onMuteDiscussionPressed,
    @required this.onUnMuteDiscussionPressed,
    @required this.onDiscussionPressed,
    @required this.currentUser,
    this.durationBeforeAutoRefresh,
    this.slidableController,
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

        /* Select the current open list */
        return Consumer<HomePageTabNotifier>(
          builder: (context, currentTab, _) {
            var showedDiscussions = <Discussion>[];
            switch (currentTab.value) {
              case HomePageTab.ARCHIVED:
                showedDiscussions = state.archivedDiscussions;
                break;
              case HomePageTab.ACTIVE:
                showedDiscussions = state.activeDiscussions;
                break;
              case HomePageTab.TRASHED:
                showedDiscussions = state.deletedDiscussions;
                break;
            }

            if (state is DiscussionListLoading &&
                showedDiscussions.length == 0) {
              return Center(child: CircularProgressIndicator());
            } else if (showedDiscussions.length == 0) {
              return Center(
                child: Container(
                  margin: EdgeInsets.all(SpacingValues.large),
                  child: getEmptyLisWidget(context, currentTab.value),
                ),
              );
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
            var duration =
                this.durationBeforeAutoRefresh ?? Duration(minutes: 20);
            if (state is DiscussionListHasTimestamp &&
                DateTime.now().difference(state.timestamp) > duration) {
              BlocProvider.of<DiscussionListBloc>(context)
                  .add(DiscussionListFetchEvent());
            }

            return AnimatedSizeContainer(
              builder: (context) {
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
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: showedDiscussions.length + 2,
                    itemBuilder: (context, index) {
                      if (index-- == 0) return errorWidget;
                      if (index-- == 0) return PendingRequestsButton();
                      var discussionElem = showedDiscussions[index];
                      return SingleChat(
                        discussion: discussionElem,
                        canJoinDiscussions: currentUser?.isTwitterAuth ?? false,
                        slidableController: this.slidableController,
                        onJoinPressed: () {
                          this.onJoinDiscussionPressed(discussionElem);
                        },
                        onPressed: () {
                          this.onDiscussionPressed(discussionElem);
                        },
                        onDeletePressed: () {
                          this.onDeleteDiscussionPressed(discussionElem);
                        },
                        onArchivePressed: () {
                          this.onArchiveDiscussionPressed(discussionElem);
                        },
                        onActivatePressed: () {
                          this.onActivateDiscussionPressed(discussionElem);
                        },
                        onMutePressed: () {
                          this.onMuteDiscussionPressed(discussionElem);
                        },
                        onUnMutePressed: () {
                          this.onUnMuteDiscussionPressed(discussionElem);
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }

  Widget getEmptyLisWidget(BuildContext context, HomePageTab value) {
    switch (value) {
      case HomePageTab.ACTIVE:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              Intl.message(
                  "Looks like you haven’t been invited to any discussions."),
              style: TextThemes.onboardHeading,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: SpacingValues.mediumLarge,
            ),
            JoinActionButton(
              padding: EdgeInsets.all(SpacingValues.mediumLarge),
              onPressed: () {
                BlocProvider.of<DiscussionListBloc>(context)
                    .add(DiscussionListFetchEvent());
              },
              child: Text(
                Intl.message("Try to reload"),
                style:
                    TextThemes.goIncognitoButton.copyWith(color: Colors.black),
              ),
            )
          ],
        );

      case HomePageTab.ARCHIVED:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              Intl.message("There are no archived chats."),
              style: TextThemes.onboardHeading,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: SpacingValues.mediumLarge,
            ),
            Text(
              Intl.message(
                  "When a chat is archived you maintain your participant status, but you will not receive any notifications for new updates."),
              textAlign: TextAlign.center,
              style: TextThemes.onboardBody,
            ),
          ],
        );

      case HomePageTab.TRASHED:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              Intl.message("You didn't delete any chat yet."),
              style: TextThemes.onboardHeading,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: SpacingValues.mediumLarge,
            ),
            Text(
              Intl.message(
                  "You can delete a chat if you don't wish to participate in it anymore.\nDeleted chats will disappear from your feed after 90 days from the deletion."),
              textAlign: TextAlign.center,
              style: TextThemes.onboardBody,
            ),
          ],
        );
    }
    return Container();
  }
}
