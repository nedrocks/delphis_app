import 'package:delphis_app/bloc/auth/auth_bloc.dart';
import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/bloc/discussion_post/discussion_post_bloc.dart';
import 'package:delphis_app/bloc/me/me_bloc.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/screens/discussion/discussion_announcement_post.dart';
import 'package:delphis_app/screens/discussion/overlay/animated_discussion_popup.dart';
import 'package:delphis_app/screens/discussion/overlay/gone_incognito_popup_contents.dart';
import 'package:delphis_app/screens/discussion/overlay/participant_settings.dart';
import 'package:delphis_app/widgets/input/delphis_input.dart';
import 'package:delphis_app/widgets/more/more_button.dart';
import 'package:delphis_app/widgets/profile_image/moderator_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  bool _isShowParticipantSettings;

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    this.hasAcceptedIncognitoWarning = false;
    _scrollController = ScrollController();
    this._isShowParticipantSettings = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscussionBloc, DiscussionState>(
      builder: (context, state) {
        if (state is DiscussionUninitializedState ||
            state is DiscussionLoadingState) {
          return Center();
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
                final post =
                    DiscussionPost(discussion: discussionObj, index: index);
                if (true) {
                  return post;
                } else {
                  // TODO: This should be hooked up to announcement posts.
                  return DiscussionAnnouncementPost(post: post);
                }
              }),
        );
        Widget listViewOverlay = listViewBuilder;
        if (this._isShowParticipantSettings) {
          listViewOverlay = AnimatedDiscussionPopup(
            child: listViewBuilder,
            popup: DiscussionPopup(
              contents: ParticipantSettings(
                  meParticipant: state.getDiscussion().meParticipant,
                  me: this._extractMe(BlocProvider.of<MeBloc>(context).state),
                  onClose: () {
                    this.setState(() {
                      this._isShowParticipantSettings = false;
                    });
                  }),
            ),
            animationMillis: 500,
          );
        }
        final expandedConversationView = Expanded(
          child: listViewOverlay,
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
                            // TODO: This will log us out for now. Add a menu here though.
                            BlocProvider.of<AuthBloc>(context)
                                .add(LogoutAuthEvent());
                          },
                        ),
                      ],
                    ),
                  ],
                )),
            expandedConversationView,
            DelphisInput(
              discussion: state.getDiscussion(),
              participant: state.getDiscussion().meParticipant,
              isShowingParticipantSettings: this._isShowParticipantSettings,
              onParticipantSettingsPressed: () {
                setState(() {
                  this._isShowParticipantSettings =
                      !this._isShowParticipantSettings;
                });
              },
            ),
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
            animationMillis: 0,
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

  User _extractMe(MeState state) {
    if (state is LoadedMeState) {
      return state.me;
    } else {
      // This should never happen and we should probably throw an error here?
      return null;
    }
  }
}
