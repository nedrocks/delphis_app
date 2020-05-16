import 'package:delphis_app/bloc/auth/auth_bloc.dart';
import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/bloc/me/me_bloc.dart';
import 'package:delphis_app/bloc/participant/participant_bloc.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/design/colors.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';

import 'discussion_header/participant_images.dart';
import 'discussion_post.dart';
import 'overlay/discussion_popup.dart';

class DelphisDiscussion extends StatefulWidget {
  final String discussionID;

  const DelphisDiscussion({
    @required this.discussionID,
  }) : super();

  @override
  State<StatefulWidget> createState() => DelphisDiscussionState();
}

class DelphisDiscussionState extends State<DelphisDiscussion> {
  bool hasSentLoadingEvent;
  bool hasAcceptedIncognitoWarning;
  bool _isShowParticipantSettings;

  ScrollController _scrollController;
  Participant _fakeParticipant;

  @override
  void initState() {
    super.initState();

    this.hasSentLoadingEvent = false;

    this.hasAcceptedIncognitoWarning = false;
    _scrollController = ScrollController();
    this._isShowParticipantSettings = false;
    this._fakeParticipant = Participant(
      participantID: 0,
      discussion: null,
      viewer: null,
      posts: <Post>[],
      isAnonymous: true,
      gradientColor: gradientColorFromGradientName(randomAnonymousGradient()),
      flair: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!this.hasSentLoadingEvent) {
      this.setState(() {
        BlocProvider.of<DiscussionBloc>(context)
            .add(DiscussionQueryEvent(discussionID: this.widget.discussionID));
        this.hasSentLoadingEvent = true;
      });
    }
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
        print(
            'received updated discussion state; num posts: ${state.getDiscussion()?.posts?.length}');
        if (state is DiscussionLoadedState &&
            state.discussionPostStream == null) {
          BlocProvider.of<DiscussionBloc>(context)
              .add(SubscribeToDiscussionEvent(this.widget.discussionID, true));
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
                final post = DiscussionPost(
                    discussion: discussionObj,
                    index: index,
                    isLocalPost:
                        discussionObj.posts[index].isLocalPost ?? false);
                if (true) {
                  return post;
                } else {
                  // TODO: This should be hooked up to announcement posts.
                  return DiscussionAnnouncementPost(post: post);
                }
              }),
        );
        Widget listViewOverlay = listViewBuilder;
        if (discussionObj.meParticipant == null) {
          listViewOverlay = AnimatedDiscussionPopup(
            child: listViewBuilder,
            popup: DiscussionPopup(
                contents: ParticipantSettings(
              meParticipant: this._fakeParticipant,
              me: this._extractMe(BlocProvider.of<MeBloc>(context).state),
              onClose: () {
                // TODO: Show a spinner
              },
              discussion: discussionObj,
              settingsFlow: SettingsFlow.JOIN_CHAT,
            )),
            animationMillis: 500,
          );
        } else if (this._isShowParticipantSettings &&
            !(discussionObj.meParticipant.hasJoined ?? false)) {
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
                },
                discussion: discussionObj,
              ),
            ),
            animationMillis: 500,
          );
        }
        final expandedConversationView = Expanded(
          child: listViewOverlay,
        );
        print('me participant: ${discussionObj.meParticipant}');
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
            discussionObj.meParticipant == null
                ? Container(width: 0, height: 0)
                : DelphisInput(
                    discussion: discussionObj,
                    participant: discussionObj.meParticipant,
                    isShowingParticipantSettings:
                        this._isShowParticipantSettings,
                    onParticipantSettingsPressed: () {
                      setState(() {
                        this._isShowParticipantSettings =
                            !this._isShowParticipantSettings;
                      });
                    },
                    parentScrollController: this._scrollController,
                  ),
          ],
        );
        Widget toRender = listViewWithInput;
        if (discussionObj.meParticipant != null &&
            !this.hasAcceptedIncognitoWarning &&
            !(discussionObj.meParticipant.hasJoined ?? false)) {
          toRender = AnimatedDiscussionPopup(
            child: listViewWithInput,
            popup: DiscussionPopup(
              contents: GoneIncognitoDiscussionPopupContents(
                moderator: discussionObj.moderator.userProfile,
                onAccept: () {
                  BlocProvider.of<ParticipantBloc>(context).add(
                      ParticipantJoinedDiscussion(
                          participant: discussionObj.meParticipant));
                  this.setState(() => this.hasAcceptedIncognitoWarning = true);
                },
              ),
            ),
            animationMillis: 0,
          );
        }
        return SafeArea(
            child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.black,
          body: toRender,
        ));
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
