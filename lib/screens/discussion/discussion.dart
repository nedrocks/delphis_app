import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/bloc/discussion_post/discussion_post_bloc.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/screens/discussion/overlay/animated_discussion_popup.dart';
import 'package:delphis_app/screens/discussion/overlay/gone_incognito_popup_contents.dart';
import 'package:delphis_app/widgets/input/delphis_input.dart';
import 'package:delphis_app/widgets/more/more_button.dart';
import 'package:delphis_app/widgets/profile_image/moderator_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'discussion_header/participant_images.dart';
import 'discussion_post.dart';
import 'overlay/discussion_popup.dart';

class DelphisDiscussion extends StatefulWidget {
  const DelphisDiscussion() : super();

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
        if (state is DiscussionUninitializedState ||
            state is DiscussionLoadingState) {
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
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Color.fromRGBO(151, 151, 151, 1.0))),
          ),
          child: ListView.builder(
              key: Key('discussion-posts-' + state.getDiscussion().id),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: discussionObj.posts.length,
              controller: this._scrollController,
              reverse: true,
              itemBuilder: (context, index) {
                return DiscussionPost(discussion: discussionObj, index: index);
              }),
        );
        var listViewWithInput = Column(
          children: <Widget>[
            Container(
                height: HeightValues.appBarHeight,
                padding:
                    EdgeInsets.symmetric(horizontal: SpacingValues.mediumLarge),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color.fromRGBO(151, 151, 151, 1.0))),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(discussionObj.title,
                          style: Theme.of(context).textTheme.headline1),
                    ),
                    Row(
                      children: <Widget>[
                        ParticipantImages(
                          height: HeightValues.appBarItemsHeight,
                          participants: discussionObj
                              .participants, //discussionObj.participants,
                        ),
                        SizedBox(width: SpacingValues.small),
                        ModeratorProfileImage(
                          diameter: HeightValues.appBarItemsHeight,
                          profileImageURL: discussionObj
                              .moderator.userProfile.profileImageURL,
                        ),
                        SizedBox(width: SpacingValues.medium),
                        MoreButton(
                          diameter: HeightValues.appBarItemsHeight,
                          onPressed: () {
                            print('more pressed');
                          },
                        ),
                      ],
                    ),
                  ],
                )),
            Expanded(
              child: listViewBuilder,
            ),
            DelphisInput(discussion: state.getDiscussion()),
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
            backgroundColor: Colors.black,
            body: toRender,
          )),
        );
      },
    );
  }
}
