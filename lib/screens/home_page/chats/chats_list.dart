import 'package:delphis_app/bloc/discussion_list/discussion_list_bloc.dart';
import 'package:delphis_app/screens/home_page/chats/single_chat.dart';
import 'package:delphis_app/screens/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsList extends StatelessWidget {
  final DiscussionCallback onJoinDiscussionPressed;
  final DiscussionCallback onDeleteDiscussionInvitePressed;
  final DiscussionCallback onDiscussionPressed;

  const ChatsList({
    @required this.onJoinDiscussionPressed,
    @required this.onDeleteDiscussionInvitePressed,
    @required this.onDiscussionPressed,
  }) : super();

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
        return ListView.builder(
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
        );
      }
    });
  }
}
