import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/bloc/discussion_post/discussion_post_bloc.dart';
import 'package:delphis_app/screens/discussion/overlay/animated_discussion_popup.dart';
import 'package:delphis_app/screens/discussion/overlay/gone_incognito_popup_contents.dart';
import 'package:delphis_app/widgets/input/delphis_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'discussion_post.dart';
import 'overlay/discussion_popup.dart';

class DelphisDiscussion extends StatefulWidget {
  const DelphisDiscussion(): super();

  @override
  State<StatefulWidget> createState() => DelphisDiscussionState();
}

class DelphisDiscussionState extends State<DelphisDiscussion> {
  bool hasAcceptedIncognitoWarning;

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    this.hasAcceptedIncognitoWarning = false;
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscussionBloc, DiscussionState>(
      builder: (context, state) {
        if (state is DiscussionUninitializedState || state is DiscussionLoadingState) {
          return Center(
            child: Text(Intl.message('Loading...')),
          );
        }
        if (state is DiscussionErrorState) {
          return Center(
            child: Text(state.error.toString()),
          );
        }
        final discussionObj = state.getDiscussion();
        var listViewBuilder = Container(
          child: ListView.builder(
            key: Key('discussion-posts-' + state.getDiscussion().id),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: discussionObj.posts.length,
            controller: this._scrollController,
            reverse: true,
            itemBuilder: (context, index) {
              return DiscussionPost(discussion: discussionObj, index: index);
            }
          ),
        );
        var listViewWithInput = Column(
          children: <Widget>[
            Expanded(
              child: listViewBuilder,
              flex: 15,
            ),
            DelphisInput(discussionId: state.getDiscussion().id),
          ],
        );
        Widget toRender = listViewWithInput;
        if (!this.hasAcceptedIncognitoWarning) {
          toRender = AnimatedDiscussionPopup(
            child: listViewWithInput,
            popup: DiscussionPopup(
              contents: GoneIncognitoDiscussionPopupContents(
                moderator: discussionObj.moderator.userProfile,
                onAccept: () {
                  this.setState(() => this.hasAcceptedIncognitoWarning = true);
                },
              ),
            ),
            animationSeconds: 0,
          );
        }
        return BlocProvider<DiscussionPostBloc>(
          create: (context) => DiscussionPostBloc(
            discussionID: discussionObj.id,
            repository: BlocProvider.of<DiscussionBloc>(context).repository,
            discussionBloc: BlocProvider.of<DiscussionBloc>(context),
          ),
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                title: Text(
                  discussionObj.title,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.black,
              ),
              backgroundColor: Colors.black,
              body: toRender,
            )
          ),
        );
      },
    );
  }
}