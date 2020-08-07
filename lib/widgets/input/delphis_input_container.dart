import 'dart:io';

import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/media.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:flutter/material.dart';

import 'delphis_input_mentions_popup.dart';

class DelphisInputContainer extends StatelessWidget {
  final bool hasJoined;
  final bool isJoinable;
  final Discussion discussion;
  final Participant participant;
  final bool isShowingParticipantSettings;
  final void Function(FocusNode) onParticipantSettingsPressed;
  final ScrollController parentScrollController;
  final VoidCallback onJoinPressed;
  final Function(File, MediaContentType) onMediaTap;
  final VoidCallback onModeratorButtonPressed;

  const DelphisInputContainer(
      {Key key,
      @required this.hasJoined,
      @required this.isJoinable,
      @required this.discussion,
      @required this.participant,
      @required this.isShowingParticipantSettings,
      @required this.onParticipantSettingsPressed,
      @required this.parentScrollController,
      @required this.onJoinPressed,
      @required this.onMediaTap,
      @required this.onModeratorButtonPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.discussion.meCanJoinDiscussion.response !=
        DiscussionJoinabilityResponse.ALREADY_JOINED) {
      return Container();
    } else {
      return DelphisInputMentionsPopup(
          discussion: discussion,
          participant: participant,
          isShowingParticipantSettings: this.isShowingParticipantSettings,
          onParticipantSettingsPressed: this.onParticipantSettingsPressed,
          parentScrollController: this.parentScrollController,
          onMediaTap: this.onMediaTap,
          onModeratorButtonPressed: this.onModeratorButtonPressed);
    }
  }
}
