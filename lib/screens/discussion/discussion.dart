import 'dart:io';
import 'package:delphis_app/bloc/auth/auth_bloc.dart';
import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/bloc/me/me_bloc.dart';
import 'package:delphis_app/bloc/participant/participant_bloc.dart';
import 'package:delphis_app/bloc/superpowers/superpowers_bloc.dart';
import 'package:delphis_app/bloc/notification/notification_bloc.dart';
import 'package:delphis_app/data/repository/concierge_content.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/media.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/screens/discussion/header_options_button.dart';
import 'package:delphis_app/screens/discussion/media/media_preview.dart';
import 'package:delphis_app/screens/discussion/screen_args/superpowers_arguments.dart';
import 'package:delphis_app/widgets/input/delphis_input_container.dart';
import 'package:delphis_app/widgets/overlay/overlay_top_message.dart';
import 'package:delphis_app/widgets/text_overlay_notification/incognito_mode_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'discussion_content.dart';
import 'discussion_header.dart';
import 'screen_args/discussion_naming.dart';

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
  FocusNode _lastFocusedNode;

  ScrollController _scrollController;
  RefreshController _refreshController;

  OverlayEntry _contentOverlayEntry;

  Key _key;

  Widget mediaToShow;

  SuperpowersArguments _superpowersPopupArguments;

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
    this._lastFocusedNode = null;
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

  void handleConciergePostOptionPressed(Discussion discussion, Post post,
      ConciergeContent content, ConciergeOption option) async {
    if (option != null) {
      if (content.appActionID != null) {
        // This means something will happen within the app. The only one we have so far is copy
        // to clipboard.
        switch (content.appActionID) {
          case ConciergeOption.kAppActionCopyToClipboard:
            Clipboard.setData(ClipboardData(text: option.value));
            BlocProvider.of<NotificationBloc>(context).add(NewNotificationEvent(
                notification: OverlayTopMessage(
              child: IncognitoModeTextOverlay(
                  hasGoneIncognito: false, textOverride: "Copied to clipboard"),
              onDismiss: () {
                BlocProvider.of<NotificationBloc>(context)
                    .add(DismissNotification());
              },
            )));
            break;
          case ConciergeOption.kAppActionRenameChat:
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, '/Discussion/Naming',
                  arguments: DiscussionNamingArguments(
                      title: discussion.title,
                      discussionID: discussion.id,
                      selectedEmoji: discussion.getEmojiIcon()));
            });
            BlocProvider.of<DiscussionBloc>(context).add(
                NextDiscussionOnboardingConciergeStep(nonce: DateTime.now()));
            break;
          default:
            break;
        }
      } else if (content.mutationID != null) {
        BlocProvider.of<DiscussionBloc>(context).add(
          DiscussionConciergeOptionSelectedEvent(
              discussionID: discussion.id,
              mutationID: content.mutationID,
              selectedOptionIDs: [option.value]),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDiscussionBlocState =
        BlocProvider.of<DiscussionBloc>(context).state;
    if (!this.hasSentLoadingEvent &&
        (!(currentDiscussionBlocState is DiscussionLoadedState) ||
            currentDiscussionBlocState.getDiscussion().id !=
                this.widget.discussionID)) {
      this.setState(() {
        BlocProvider.of<DiscussionBloc>(context)
            .add(DiscussionQueryEvent(discussionID: this.widget.discussionID));
        this.hasSentLoadingEvent = true;
      });
    } else {
      this.hasSentLoadingEvent = true;
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

        /* In some old discussions the moderator was able to go in incognito mode.
           if this happens, then we re-force to non-incognito mode. By using BLoCs,
           the UI is rebuilt automatically. */
        if ((discussionObj?.meParticipant?.isAnonymous ?? false) &&
            (discussionObj?.isMeDiscussionModerator() ?? false)) {
          BlocProvider.of<ParticipantBloc>(context)
              .add(ParticipantEventUpdateParticipant(
            participantID: discussionObj.meParticipant.id,
            isAnonymous: false,
            gradientName: gradientNameFromString(
                discussionObj.meParticipant.gradientColor),
            flair: discussionObj.meParticipant.flair,
            isUnsetFlairID: discussionObj.meParticipant.flair == null,
          ));
        }

        final expandedConversationView = Expanded(
          child: DiscussionContent(
            key: Key('${this._key}-content'),
            refreshController: this._refreshController,
            scrollController: this._scrollController,
            discussion: discussionObj,
            isDiscussionVisible: true,
            isShowParticipantSettings: this._isShowParticipantSettings,
            isAnimationEnabled: this._lastFocusedNode == null,
            isShowJoinFlow: this._isShowJoinFlow,
            onJoinFlowClose: (bool isJoined) {
              if (isJoined) {
                // This is kinda gross but we need to reload the discussion here because
                // of state management concerns. This is simpler than untangling the mess
                // of dependencies involved.
                BlocProvider.of<DiscussionBloc>(context).add(
                    DiscussionQueryEvent(
                        discussionID: this.widget.discussionID,
                        nonce: DateTime.now()));
              }
              setState(() {
                this._isShowJoinFlow = false;
                this._contentOverlayEntry.remove();
                this._contentOverlayEntry = null;
              });
            },
            onSettingsOverlayClose: (_) {
              this.setState(() {
                _restoreFocusAndDismissOverlay();
              });
            },
            onOverlayOpen: (OverlayEntry entry) {
              this._onOverlayEntry(context, entry);
            },
            onboardingConciergeStep:
                (state as DiscussionLoadedState).onboardingConciergeStep,
            onConciergeOptionPressed:
                (Post post, ConciergeContent content, ConciergeOption option) {
              this.handleConciergePostOptionPressed(
                  discussionObj, post, content, option);
            },
            onMediaTap: (media, type) => this.onMediaTap(context, media, type),
            onSuperpowersButtonPressed: (arguments) {
              showSuperpowersPopup(context, arguments);
            },
            onModeratorOverlayClose: () {
              this.setState(() {
                this._superpowersPopupArguments = null;
                _restoreFocusAndDismissOverlay();
              });
            },
            superpowersArguments: this._superpowersPopupArguments,
          ),
        );
        final me = MeBloc.extractMe(BlocProvider.of<MeBloc>(context).state);
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
              hasJoined: discussionObj?.meParticipant?.hasJoined ?? false,
              isJoinable: (me != null && me.isTwitterAuth),
              discussion: discussionObj,
              participant: discussionObj.meParticipant,
              isShowingParticipantSettings: this._isShowParticipantSettings,
              parentScrollController: this._scrollController,
              onParticipantSettingsPressed: (lastFocusedNode) {
                setState(() {
                  this._lastFocusedNode = lastFocusedNode;
                  this._isShowParticipantSettings =
                      !this._isShowParticipantSettings;
                });
              },
              onJoinPressed: () {
                setState(() {
                  this._isShowJoinFlow = true;
                });
              },
              onMediaTap: (media, type) {
                onMediaTap(context, media, type);
              },
              onModeratorButtonPressed: () {
                showSuperpowersPopup(context,
                    SuperpowersArguments(discussion: state.getDiscussion()));
              },
            ),
          ],
        );

        Widget toRender = SafeArea(
            child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.black,
          body: listViewWithInput,
        ));

        Widget mediaPreview = Container();
        if (this.mediaToShow != null) {
          mediaPreview = mediaToShow;
        }

        return Stack(
          children: [
            toRender,
            Center(
              child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(child: child, scale: animation);
                  },
                  child: mediaPreview),
            )
          ],
        );
      },
    );
  }

  void showSuperpowersPopup(
      BuildContext context, SuperpowersArguments arguments) {
    setState(() {
      var focusScope = FocusScope.of(context);
      if (focusScope.hasFocus) {
        this._lastFocusedNode = focusScope.focusedChild;
        focusScope.unfocus();
      }
      this._superpowersPopupArguments = arguments;
    });
  }

  void onMediaTap(BuildContext context, File media, MediaContentType type) {
    setState(() {
      /* Dismiss everything could be possibly interfere */
      this._lastFocusedNode = null;
      FocusScope.of(context).unfocus();
      _dismissOverlay();

      /* Set the media to be shown */
      this.mediaToShow = MediaPreviewWidget(
        mediaFile: media,
        mediaType: type,
        onCancel: this.cancelPreview,
      );
    });
  }

  void cancelPreview() {
    setState(() {
      this.mediaToShow = null;
    });
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

  void _restoreFocusAndDismissOverlay() {
    if (this._lastFocusedNode != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(this._lastFocusedNode);
        this._lastFocusedNode = null;
      });
    }
    _dismissOverlay();
  }

  void _dismissOverlay() {
    BlocProvider.of<SuperpowersBloc>(context).add(ResetEvent());
    this._superpowersPopupArguments = null;
    this._isShowParticipantSettings = false;
    if (this._contentOverlayEntry != null) {
      this._contentOverlayEntry.remove();
      this._contentOverlayEntry = null;
    }
  }
}
