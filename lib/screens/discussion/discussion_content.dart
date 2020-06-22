import 'package:delphis_app/bloc/me/me_bloc.dart';
import 'package:delphis_app/bloc/notification/notification_bloc.dart';
import 'package:delphis_app/bloc/participant/participant_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/util/callbacks.dart';
import 'package:delphis_app/widgets/overlay/overlay_top_message.dart';
import 'package:delphis_app/widgets/text_overlay_notification/incognito_mode_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'discussion_post_list_view.dart';
import 'overlay/animated_discussion_popup.dart';
import 'overlay/discussion_popup.dart';
import 'overlay/participant_settings.dart';

class DiscussionContent extends StatelessWidget {
  final ScrollController scrollController;
  final Discussion discussion;
  final bool isDiscussionVisible;
  final bool isShowParticipantSettings;
  final bool isShowJoinFlow;
  final bool isAnimationEnabled;

  final SuccessCallback onJoinFlowClose;
  final SuccessCallback onSettingsOverlayClose;
  final OverlayEntryCallback onOverlayOpen;
  final RefreshController refreshController;

  DiscussionContent({
    @required key,
    @required this.scrollController,
    @required this.discussion,
    @required this.isDiscussionVisible,
    @required this.onJoinFlowClose,
    @required this.isShowParticipantSettings,
    @required this.isShowJoinFlow,
    @required this.isAnimationEnabled,
    @required this.onSettingsOverlayClose,
    @required this.onOverlayOpen,
    @required this.refreshController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget postListView = DiscussionPostListView(
      key: Key('${this.key}-postlist'),
      isRefreshEnabled: !this.isShowJoinFlow && !this.isShowParticipantSettings,
      discussion: this.discussion,
      scrollController: this.scrollController,
      isVisible: true,
      refreshController: this.refreshController,
    );
    if (this.isShowJoinFlow) {
      final participantBloc = BlocProvider.of<ParticipantBloc>(context);
      final overlayEntry = OverlayEntry(
        builder: (BuildContext context) {
          return AnimatedDiscussionPopup(
            child: Container(width: 0, height: 0),
            popup: DiscussionPopup(
              contents: ParticipantSettings(
                meParticipant: Participant(
                  participantID: 0,
                  discussion: null,
                  viewer: null,
                  posts: <Post>[],
                  isAnonymous: true,
                  gradientColor:
                      gradientColorFromGradientName(randomAnonymousGradient()),
                  flair: null,
                ),
                me: MeBloc.extractMe(BlocProvider.of<MeBloc>(context).state),
                onClose: this.onJoinFlowClose,
                discussion: this.discussion,
                settingsFlow: SettingsFlow.JOIN_CHAT,
                participantBloc: participantBloc,
              ),
            ),
            animationMillis: 500,
          );
        },
      );

      this.onOverlayOpen(overlayEntry);
    } else if (this.isShowParticipantSettings) {
      final participantBloc = BlocProvider.of<ParticipantBloc>(context);
      final notificationBloc = BlocProvider.of<NotificationBloc>(context);
      final overlayEntry = OverlayEntry(
        builder: (context) => AnimatedDiscussionPopup(
          child: Container(width: 0, height: 0),
          popup: DiscussionPopup(
            contents: ParticipantSettings(
              discussion: this.discussion,
              meParticipant: this.discussion.meParticipant,
              me: MeBloc.extractMe(BlocProvider.of<MeBloc>(context).state),
              participantBloc: participantBloc,
              onClose: (didUpdate) {
                if (didUpdate) {
                  notificationBloc.add(
                    NewNotificationEvent(
                      notification: OverlayTopMessage(
                        child: IncognitoModeTextOverlay(
                          hasGoneIncognito: didUpdate
                              ? !this.discussion.meParticipant.isAnonymous
                              : this.discussion.meParticipant.isAnonymous,
                        ),
                        onDismiss: () {
                          notificationBloc.add(DismissNotification());
                        },
                      ),
                    ),
                  );
                }
                this.onSettingsOverlayClose(didUpdate);
              },
            ),
          ),
          animationMillis: this.isAnimationEnabled ? 500 : 0,
        ),
      );

      this.onOverlayOpen(overlayEntry);
    }

    return postListView;
  }
}
