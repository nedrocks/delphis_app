import 'package:delphis_app/bloc/me/me_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/util/callbacks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'discussion_post_list_view.dart';
import 'overlay/animated_discussion_popup.dart';
import 'overlay/discussion_popup.dart';
import 'overlay/participant_settings.dart';
import 'settings_overlay_discussion_post_list_view.dart';

class DiscussionContent extends StatelessWidget {
  final ScrollController scrollController;
  final Discussion discussion;
  final bool isDiscussionVisible;
  final bool isShowParticipantSettings;
  final bool isShowJoinFlow;

  final SuccessCallback onJoinFlowClose;
  final SuccessCallback onSettingsOverlayClose;

  const DiscussionContent({
    @required this.scrollController,
    @required this.discussion,
    @required this.isDiscussionVisible,
    @required this.onJoinFlowClose,
    @required this.isShowParticipantSettings,
    @required this.isShowJoinFlow,
    @required this.onSettingsOverlayClose,
  }) : super();

  @override
  Widget build(BuildContext context) {
    Widget postListView = DiscussionPostListView(
      discussion: this.discussion,
      scrollController: this.scrollController,
      isVisible: true,
    );
    if (this.isShowJoinFlow) {
      postListView = AnimatedDiscussionPopup(
        child: postListView,
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
        )),
        animationMillis: 500,
      );
    } else if (this.isShowParticipantSettings) {
      postListView = SettingsOverlayDiscussionPostListView(
        scrollController: this.scrollController,
        discussion: this.discussion,
        isDiscussionVisible: true,
        onClose: this.onSettingsOverlayClose,
      );
    }

    return postListView;
  }
}
