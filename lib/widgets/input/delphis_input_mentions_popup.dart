import 'dart:math';
import 'dart:ui';

import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/util/display_names.dart';
import 'package:delphis_app/widgets/input/participant_mention_hint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

import 'delphis_input.dart';
import 'delphis_text_controller.dart';

class DelphisInputMentionsPopup extends StatefulWidget {

  final Discussion discussion;
  final Participant participant;
  final bool isShowingParticipantSettings;
  final void Function(FocusNode) onParticipantSettingsPressed;
  final ScrollController parentScrollController;

  DelphisInputMentionsPopup({
    @required this.discussion,
    @required this.participant,
    @required this.isShowingParticipantSettings,
    @required this.onParticipantSettingsPressed,
    this.parentScrollController,
  });

  @override
  _DelphisInputMentionsPopupState createState() => _DelphisInputMentionsPopupState();

}

class _DelphisInputMentionsPopupState extends State<DelphisInputMentionsPopup> {
  final popupEntryHeight = 55.0;
  final popupMaxEntries = 4;
  final popupWidth = 320.0;
  double popupHeight;
  DelphisTextEditingController textController;
  FocusNode textFocusNode;
  OverlayEntry overlayEntry;
  LayerLink layerLink;
  Future<List<Participant>> participantsHint;

  @override
  void initState() {
    this.textController = DelphisTextEditingController();
    this.textFocusNode = FocusNode();
    this.layerLink = LayerLink();

    var toggleOverlay = () {
      if (textFocusNode.hasFocus) {
        this.overlayEntry?.remove();
        this.overlayEntry = this.createOverlayEntry();
        Overlay.of(context).insert(this.overlayEntry);
      } else {
        this.overlayEntry?.remove();
        this.overlayEntry = null;
      }
    };

    this.textFocusNode.addListener(toggleOverlay);
    this.textController.addListener(() {
      var participantMention = getLastParticipantMentionAttempt();
      this.popupHeight = 0;
      if(participantMention != null) {
        setState(() {
          participantsHint = getParticipantHints(this.textController.text, participantMention);
          this.popupHeight = popupEntryHeight;
          participantsHint.then((value) => setState(() {
            popupHeight = min(popupMaxEntries.toDouble(), value.length.toDouble()) * popupEntryHeight;
            SchedulerBinding.instance.addPostFrameCallback((_) => toggleOverlay());
          }));
          SchedulerBinding.instance.addPostFrameCallback((_) => toggleOverlay());
        });
      }

      SchedulerBinding.instance.addPostFrameCallback((_) => toggleOverlay());
    });

    this.popupHeight = 0;
    super.initState();
  }

  @override
  void dispose() {
    this.textController.dispose();
    this.textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this.layerLink,
      child: DelphisInput(
        discussion: widget.discussion,
        participant: widget.participant,
        isShowingParticipantSettings: widget.isShowingParticipantSettings,
        onParticipantSettingsPressed: widget.onParticipantSettingsPressed,
        parentScrollController: widget.parentScrollController,
        inputFocusNode: this.textFocusNode,
        textController: this.textController,
      )
    );
  }

  OverlayEntry createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width,
        height: popupHeight,
        child: CompositedTransformFollower(
          link: this.layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, -popupHeight),
          child: buildFuturePopup(context),
        ),
      )
    );
  }

  Widget buildFuturePopup(BuildContext context) {
    if(popupHeight == 0)
      return Container();
    return FutureBuilder(
      future: this.participantsHint,
      builder: (context, snapshot) {
        Widget toDraw;
        if(snapshot.hasError) {
          toDraw = Text(Intl.message("An error has occurred!"));
        } else if (snapshot.hasData) {
          toDraw = buildParticipantsPopup(context, snapshot.data);
        } else {
          toDraw = CupertinoActivityIndicator();
        }
        return Center(
          child: Container(
            width: popupWidth,
            height: popupHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft : Radius.circular(20), topRight : Radius.circular(20)),
                color: Colors.grey.withOpacity(0.9)
              ),
              padding: EdgeInsets.all(SpacingValues.smallMedium),
              child: toDraw,
            )
        );
        
      },
    );
  }

  Widget buildParticipantsPopup(BuildContext context, List<Participant> participants) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      
      shrinkWrap: false,
      itemCount: participants.length,
      itemBuilder: (context, index) {
        return ParticipantMentionHintWidget(
          participant: participants[index],
          moderator: this.widget.discussion.moderator,
          onTap: () {
            participantMentionAutoComplete(participants[index]);
          },
        );
      }
    );
  }


  String getLastParticipantMentionAttempt() {
    var text = textController.text;
    var offset = textController.selection.baseOffset;
    if(offset < 0 || offset > text.length)
      return null;
    text = text.substring(0, offset);
    RegExp regex = RegExp(DisplayNames.participantMentionRegexPattern);
    if(regex.hasMatch(text)) {
      var matches = regex.allMatches(text);
      var match = matches.last.group(0).substring(1);
      if ((match.length == 0 && text.endsWith(DisplayNames.participantMentionSymbol)) || (match.length > 0 && text.endsWith(match)))
        return match;
    }
    return null;
  }

  void participantMentionAutoComplete(Participant participant) {
    var hint = DisplayNames.formatParticipantMention(this.widget.discussion.moderator, participant);
    var hintWithSymbol = DisplayNames.formatParticipantMentionWithSymbol(this.widget.discussion.moderator, participant);
    var attempt = getLastParticipantMentionAttempt();
    var text = textController.text;
    var offset = textController.selection.baseOffset;

    // TODO: Color the hint (might need to create a custom textcontroller class)
    var newText = text.substring(0, offset - attempt.length) + hint + " ";
    var newSelection = this.textController.selection.copyWith(baseOffset : newText.length, extentOffset : newText.length);
    newText += text.substring(offset);

    this.textController.regexPatternStyle[RegExp("$hintWithSymbol")] = 
        (s) => s.copyWith(color : Colors.lightBlue, fontWeight: FontWeight.bold);
    this.textController.text = newText;
    this.textController.selection = newSelection;
    this.textController.notifyListeners();
  }

  Future<List<Participant>> getParticipantHints(String wholeText, String mention) {
    var list = this.widget.discussion.participants
        .where((e) => 
          DisplayNames.formatParticipant(this.widget.discussion.moderator, e).toLowerCase()
            .startsWith(mention.toLowerCase()))
        /* Block the user from mentioning themselves */
        .where((e) => e.id != this.widget.discussion.meParticipant.id)
        /* Block the user from mentioning someone twice */
        .where((e) => !wholeText.contains(DisplayNames.formatParticipantMentionWithSymbol(this.widget.discussion.moderator, e)))
        .toList();
    list.sort((a, b) {
      return DisplayNames.formatParticipantMention(this.widget.discussion.moderator, a).
        compareTo(DisplayNames.formatParticipantMention(this.widget.discussion.moderator, b));
    });
    return Future.value(list);
  }

}