import 'dart:io';

import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/media.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  const DelphisInputContainer({
    Key key,
    @required this.hasJoined,
    @required this.isJoinable,
    @required this.discussion,
    @required this.participant,
    @required this.isShowingParticipantSettings,
    @required this.onParticipantSettingsPressed,
    @required this.parentScrollController,
    @required this.onJoinPressed,
    @required this.onMediaTap,
    @required this.onModeratorButtonPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!this.hasJoined) {
      Widget buttonWidget;
      if (this.isJoinable) {
        buttonWidget = RaisedButton(
          onPressed: this.onJoinPressed,
          child: Text(Intl.message('Join chat'),
              style: TextThemes.joinButtonTextChatTab),
          color: Color.fromRGBO(247, 247, 255, 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0),
          ),
        );
      } else {
        buttonWidget = RaisedButton(
          onPressed: null,
          child: Text(
            Intl.message("You can't join this right now"),
            style: TextThemes.joinButtonTextChatTab
                .copyWith(color: Color.fromRGBO(247, 247, 255, 1.0)),
          ),
          disabledColor: Color.fromRGBO(62, 62, 76, 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0),
          ),
        );
      }
      return Padding(
        padding: EdgeInsets.symmetric(
            vertical: SpacingValues.medium, horizontal: SpacingValues.small),
        child: Container(
            height: 40.0, width: double.infinity, child: buttonWidget),
      );
    } else {
      return DelphisInputMentionsPopup(
        discussion: discussion,
        participant: participant,
        isShowingParticipantSettings: this.isShowingParticipantSettings,
        onParticipantSettingsPressed: this.onParticipantSettingsPressed,
        parentScrollController: this.parentScrollController,
        onMediaTap: this.onMediaTap,
        onModeratorButtonPressed: this.onModeratorButtonPressed
      );
    }
  }
}
