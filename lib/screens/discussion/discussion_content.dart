import 'dart:io';

import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/bloc/me/me_bloc.dart';
import 'package:delphis_app/bloc/participant/participant_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/media.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/screens/superpowers/superpowers_arguments.dart';
import 'package:delphis_app/util/callbacks.dart';
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
  final bool isShowJoinFlow;
  final bool isAnimationEnabled;

  final SuccessCallback onJoinFlowClose;
  final SuccessCallback onSettingsOverlayClose;
  final OverlayEntryCallback onOverlayOpen;
  final RefreshController refreshController;

  final Function(File, MediaContentType) onMediaTap;
  final Function(SuperpowersArguments) onSuperpowersButtonPressed;
  final Function(LocalPost) onLocalPostRetryPressed;

  const DiscussionContent({
    @required key,
    @required this.scrollController,
    @required this.discussion,
    @required this.isDiscussionVisible,
    @required this.onJoinFlowClose,
    @required this.isShowJoinFlow,
    @required this.isAnimationEnabled,
    @required this.onSettingsOverlayClose,
    @required this.onOverlayOpen,
    @required this.refreshController,
    @required this.onMediaTap,
    @required this.onSuperpowersButtonPressed,
    @required this.onLocalPostRetryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget postListView = DiscussionPostListView(
      key: Key('${this.key}-postlist'),
      isRefreshEnabled: !this.isShowJoinFlow,
      discussion: this.discussion,
      scrollController: this.scrollController,
      isVisible: true,
      refreshController: this.refreshController,
      onMediaTap: this.onMediaTap,
      onSuperpowersButtonPressed: this.onSuperpowersButtonPressed,
      onLocalPostRetryPressed: this.onLocalPostRetryPressed,
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
                ),
                me: MeBloc.extractMe(BlocProvider.of<MeBloc>(context).state),
                onClose: this.onJoinFlowClose,
                discussion: this.discussion,
                settingsFlow: SettingsFlow.JOIN_CHAT,
                participantBloc: participantBloc,
              ),
            ),
            animationMillis: 200,
          );
        },
      );

      this.onOverlayOpen(overlayEntry);
    }
    return postListView;
  }
}
