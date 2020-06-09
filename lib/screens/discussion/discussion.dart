import 'package:delphis_app/bloc/auth/auth_bloc.dart';
import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/screens/discussion/header_options_button.dart';
import 'package:delphis_app/widgets/input/delphis_input_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'discussion_content.dart';
import 'discussion_header.dart';

class DiscussionArguments {
  final String discussionID;
  final bool isStartJoinFlow;

  DiscussionArguments({
    @required this.discussionID,
    this.isStartJoinFlow = false,
  });
}

class DelphisDiscussion extends StatefulWidget {
  final String discussionID;
  final bool isStartJoinFlow;

  const DelphisDiscussion({
    key,
    @required this.discussionID,
    @required this.isStartJoinFlow,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => DelphisDiscussionState();
}

class DelphisDiscussionState extends State<DelphisDiscussion> {
  bool hasSentLoadingEvent;
  bool hasAcceptedIncognitoWarning;
  bool _isShowParticipantSettings;
  bool _isShowJoinFlow;

  ScrollController _scrollController;
  RefreshController _refreshController;

  OverlayEntry _contentOverlayEntry;

  Key _key;

  @override
  void initState() {
    super.initState();

    Segment.screen(screenName: "Discussion", properties: {
      'discussionID': this.widget.discussionID,
    });

    this._isShowJoinFlow = this.widget.isStartJoinFlow;

    this.hasSentLoadingEvent = false;

    this.hasAcceptedIncognitoWarning = false;
    this._scrollController = ScrollController();
    this._refreshController = RefreshController();
    this._isShowParticipantSettings = false;

    this._key = Key(
        'discussion-${this.widget.discussionID}-${DateTime.now().millisecondsSinceEpoch}');
  }

  @override
  void deactivate() {
    if (this._contentOverlayEntry != null) {
      this._contentOverlayEntry.remove();
      this._contentOverlayEntry = null;
    }
    super.deactivate();
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
          return Center(child: CircularProgressIndicator());
        }
        if (state is DiscussionErrorState) {
          return Center(
            child: Text(state.error.toString()),
          );
        }
        if (state is DiscussionLoadedState &&
            state.discussionPostStream == null) {
          BlocProvider.of<DiscussionBloc>(context)
              .add(SubscribeToDiscussionEvent(this.widget.discussionID, true));
        }
        final discussionObj = state.getDiscussion();
        final expandedConversationView = Expanded(
          child: DiscussionContent(
            key: Key('${this._key}-content'),
            refreshController: this._refreshController,
            scrollController: this._scrollController,
            discussion: discussionObj,
            isDiscussionVisible: true,
            isShowParticipantSettings: this._isShowParticipantSettings,
            isShowJoinFlow: this._isShowJoinFlow,
            onJoinFlowClose: (bool isJoined) {
              if (isJoined) {
                // Not sure we need to do anything here?
              }
              setState(() {
                this._isShowJoinFlow = false;
                this._contentOverlayEntry.remove();
                this._contentOverlayEntry = null;
              });
            },
            onSettingsOverlayClose: (_) {
              this.setState(() {
                this._isShowParticipantSettings = false;
                this._contentOverlayEntry.remove();
                this._contentOverlayEntry = null;
              });
            },
            onOverlayOpen: (OverlayEntry entry) {
              this._onOverlayEntry(context, entry);
            },
          ),
        );
        var listViewWithInput = Column(
          children: <Widget>[
            DiscussionHeader(
              discussion: discussionObj,
              onBackButtonPressed: () {
                Navigator.of(context).pop();
              },
              onHeaderOptionSelected: (HeaderOption option) {
                switch (option) {
                  case HeaderOption.logout:
                    if (this._contentOverlayEntry != null) {
                      this._contentOverlayEntry.remove();
                    }
                    BlocProvider.of<AuthBloc>(context).add(LogoutAuthEvent());
                    break;
                  default:
                    break;
                }
              },
            ),
            expandedConversationView,
            DelphisInputContainer(
              hasJoined: discussionObj.meParticipant != null,
              isJoinable: true,
              discussion: discussionObj,
              participant: discussionObj.meParticipant,
              isShowingParticipantSettings: this._isShowParticipantSettings,
              parentScrollController: this._scrollController,
              onParticipantSettingsPressed: () {
                setState(() {
                  this._isShowParticipantSettings =
                      !this._isShowParticipantSettings;
                });
              },
              onJoinPressed: () {
                setState(() {
                  this._isShowJoinFlow = true;
                });
              },
            ),
          ],
        );
        Widget toRender = listViewWithInput;
        // if (discussionObj.meParticipant != null &&
        //     !this.hasAcceptedIncognitoWarning &&
        //     !(discussionObj.meParticipant.hasJoined ?? false)) {
        //   toRender = AnimatedDiscussionPopup(
        //     child: listViewWithInput,
        //     popup: DiscussionPopup(
        //       contents: GoneIncognitoDiscussionPopupContents(
        //         moderator: discussionObj.moderator.userProfile,
        //         onAccept: () {
        //           BlocProvider.of<ParticipantBloc>(context).add(
        //               ParticipantJoinedDiscussion(
        //                   participant: discussionObj.meParticipant));
        //           this.setState(() => this.hasAcceptedIncognitoWarning = true);
        //         },
        //       ),
        //     ),
        //     animationMillis: 0,
        //   );
        // }
        return SafeArea(
            child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.black,
          body: toRender,
        ));
      },
    );
  }

  void _onOverlayEntry(BuildContext context, OverlayEntry entry) {
    if (this._contentOverlayEntry != null) {
      // Because the child widgets are stateless this can be called multiple
      // times. Do nothing.
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        this.setState(() {
          this._contentOverlayEntry = entry;
        });
        Overlay.of(context).insert(entry);
      });
    }
  }
}
