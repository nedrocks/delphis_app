import 'package:delphis_app/bloc/discussion_list/discussion_list_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/moderator.dart';
import 'package:delphis_app/data/repository/user_profile.dart';
import 'package:delphis_app/screens/home_page/chats/single_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class ChatsScreen extends StatefulWidget {
//   const ChatsScreen() : super();

//   @override
//   State<StatefulWidget> createState() => _ChatsScreenState();
// }

class ChatsList extends StatelessWidget {
  void joinDiscussionPressed(Discussion discussion) {}

  void deleteDiscussionInvitePressed(Discussion discussion) {}

  void discussionPressed(Discussion discussion) {}

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
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.black,
            body: ListView.builder(
              key: Key('discussion-list-view'),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: discussionList.length,
              itemBuilder: (context, index) {
                final discussionElem = discussionList.elementAt(index);
                return SingleChat(
                  discussion: discussionElem,
                  onJoinPressed: () {
                    this.joinDiscussionPressed(discussionElem);
                  },
                  onDeletePressed: () {
                    this.deleteDiscussionInvitePressed(discussionElem);
                  },
                  onPressed: () {
                    this.discussionPressed(discussionElem);
                  },
                );
              },
            ),
          ),
        );
      }
    });
  }
}
