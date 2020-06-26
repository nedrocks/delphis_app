import 'dart:math';
import 'dart:ui';

import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/bloc/mention/mention_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/tracking/constants.dart';
import 'package:delphis_app/util/display_names.dart';
import 'package:delphis_app/widgets/input/participant_mention_hint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'delphis_input.dart';
import 'delphis_text_controller.dart';
import 'discussion_mention_hint.dart';

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
  final popupEntryHeight = 60.0;
  final popupMaxEntries = 3;
  final popupWidth = 320.0;
  double popupHeight;
  DelphisTextEditingController textController;
  FocusNode textFocusNode;
  OverlayEntry overlayEntry;
  LayerLink layerLink;
  Future<List<dynamic>> mentionsHints;
  MentionState mentionContext;

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
      var discussionMention = getLastDiscussionMentionAttempt();
      this.popupHeight = 0;

      /* Handle participant mentions */
      if(participantMention != null && (mentionContext?.isReady() ?? false)) {
        setState(() {
          mentionsHints = getParticipantMentionHints(this.textController.text, participantMention);
          this.popupHeight = popupEntryHeight;
          mentionsHints.then((value) => setState(() {
            popupHeight = min(popupMaxEntries.toDouble(), value.length.toDouble()) * popupEntryHeight;
            SchedulerBinding.instance.addPostFrameCallback((_) => toggleOverlay());
          }));
          SchedulerBinding.instance.addPostFrameCallback((_) => toggleOverlay());
        });
      }

      /* Handle discussion mentions */
      if(discussionMention != null && (mentionContext?.isReady() ?? false)) {
        setState(() {
          mentionsHints = getDiscussionMentionHints(this.textController.text, discussionMention);
          this.popupHeight = popupEntryHeight;
          mentionsHints.then((value) => setState(() {
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
    return BlocBuilder<MentionBloc, MentionState> (
      builder: (context, state) {
        if (state is MentionState) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            setState(() {
              this.mentionContext = state;
            });
          });       
        }
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
            onSubmit: (text) {
              final isButtonActive = text.isNotEmpty;
              final pressID = Uuid().v4();
              Segment.track(
                  eventName: ChathamTrackingEventNames.POST_ADD_BUTTON_PRESS,
                  properties: {
                    'funnelID': pressID,
                    'isActive': isButtonActive,
                    'contentLength': text.length,
                    'discussionID': this.widget.discussion.id,
                    'participantID': this.widget.participant.id,
                  });
              if (isButtonActive) {
                List<String> mentionedEntities = [];
                if(mentionContext != null && mentionContext.isReady())
                  text = mentionContext.encodePostContent(text, mentionedEntities);
                BlocProvider.of<DiscussionBloc>(context).add(
                  DiscussionPostAddEvent(
                      postContent: text,
                      uniqueID: pressID,
                      mentionedEntities: mentionedEntities,
                      localMentionedEntities: mentionedEntities.map((e) => mentionContext.metionedToLocalEntityID(e)).toList()
                  ),
                );
                textController.text = '';
              }
            },
          )
        );
      }
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
    return FutureBuilder<List<dynamic>> (
      future: this.mentionsHints,
      builder: (context, snapshot) {
        Widget toDraw;
        if(snapshot.hasError) {
          toDraw = Text(Intl.message("An error has occurred!"));
        } else if (snapshot.hasData && snapshot.data.length > 0 && snapshot.data[0] is Participant) {
          toDraw = buildParticipantsHintPopup(context, snapshot.data);
        }else if (snapshot.hasData && snapshot.data.length > 0 && snapshot.data[0] is Discussion) {
          toDraw = buildDiscussionsHintPopup(context, snapshot.data);
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

  Widget buildParticipantsHintPopup(BuildContext context, List<Participant> participants) {
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

  Widget buildDiscussionsHintPopup(BuildContext context, List<Discussion> discussions) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      
      shrinkWrap: false,
      itemCount: discussions.length,
      itemBuilder: (context, index) {
        return DiscussionMentionHintWidget(
          discussion: discussions[index],
          onTap: () {
            discussionMentionAutoComplete(discussions[index]);
          },
        );
      }
    );
  }

  String getLastMentionAttempt(RegExp regex, String mentionSymbol) {
    var text = textController.text;
    var offset = textController.selection.baseOffset;
    if(offset < 0 || offset > text.length)
      return null;
    text = text.substring(0, offset);
    if(regex.hasMatch(text)) {
      var matches = regex.allMatches(text);
      var match = matches.last.group(0).substring(1);
      if ((match.length == 0 && text.endsWith(mentionSymbol)) || (match.length > 0 && text.endsWith(match)))
        return match;
    }
    return null;
  }

  String getLastParticipantMentionAttempt() {
    var text = textController.text;
    var offset = textController.selection.baseOffset;
    if(offset < 0 || offset > text.length)
      return null;
    text = text.substring(0, offset);
    return mentionContext.getLastParticipantMentionAttempt(text);
  }

  String getLastDiscussionMentionAttempt() {
    var text = textController.text;
    var offset = textController.selection.baseOffset;
    if(offset < 0 || offset > text.length)
      return null;
    text = text.substring(0, offset);
    return mentionContext.getLastDiscussionMentionAttempt(text);
  }

  void participantMentionAutoComplete(Participant participant) {
    var hint = mentionContext.formatParticipantMention(participant);
    var hintWithSymbol = mentionContext.formatParticipantMentionWithSymbol(participant);
    var attempt = getLastParticipantMentionAttempt();
    var text = textController.text;
    var offset = textController.selection.baseOffset;

    var newText = text.substring(0, offset - attempt.length) + hint + " ";
    var newSelection = this.textController.selection.copyWith(baseOffset : newText.length, extentOffset : newText.length);
    newText += text.substring(offset);

    this.textController.regexPatternStyle[RegExp("$hintWithSymbol")] = 
        (s) => s.copyWith(color : Colors.lightBlue, fontWeight: FontWeight.bold);
    this.textController.text = newText;
    this.textController.selection = newSelection;
    this.textController.notifyListeners();
  }

  void discussionMentionAutoComplete(Discussion discussion) {
    var hint = mentionContext.formatDiscussionMention(discussion);
    var hintWithSymbol = mentionContext.formatDiscussionMentionWithSymbol(discussion);
    var attempt = getLastDiscussionMentionAttempt();
    var text = textController.text;
    var offset = textController.selection.baseOffset;

    var newText = text.substring(0, offset - attempt.length) + hint + " ";
    var newSelection = this.textController.selection.copyWith(baseOffset : newText.length, extentOffset : newText.length);
    newText += text.substring(offset);

    this.textController.regexPatternStyle[RegExp("$hintWithSymbol")] = 
        (s) => s.copyWith(color : Colors.lightBlue, fontWeight: FontWeight.bold);
    this.textController.text = newText;
    this.textController.selection = newSelection;
    this.textController.notifyListeners();
  }

  Future<List<Participant>> getParticipantMentionHints(String wholeText, String mention) {
    var list = this.mentionContext.discussion.participants
        .where((e) => 
          DisplayNames.formatParticipant(this.mentionContext.discussion.moderator, e).toLowerCase()
            .startsWith(mention.toLowerCase()))
        /* Block the user from mentioning themselves */
        .where((e) => e.id != this.widget.discussion.meParticipant.id)
        /* Block the user from mentioning someone twice */
        .where((e) => !wholeText.contains(mentionContext.formatParticipantMentionWithSymbol(e)))
        .toList();
    list.sort((a, b) {
      return DisplayNames.formatParticipant(this.mentionContext.discussion.moderator, a).
        compareTo(DisplayNames.formatParticipant(this.mentionContext.discussion.moderator, b));
    });
    return Future.value(list);
  }

  Future<List<Discussion>> getDiscussionMentionHints(String wholeText, String mention) {
    var list = this.mentionContext.visibleDiscussions
        .where((e) =>  DisplayNames.formatDiscussion(e).toLowerCase()
            .startsWith(mention.toLowerCase()))
        /* Block the user from mentioning this discussion */
        .where((e) => e.id != this.mentionContext.discussion.id)
        /* Block the user from mentioning a discussion twice */
        .where((e) => !wholeText.contains(mentionContext.formatDiscussionMentionWithSymbol(e)))
        .toList();
    list.sort((a, b) {
      return DisplayNames.formatDiscussion(a).
        compareTo(DisplayNames.formatDiscussion(b));
    });
    return Future.value(list);
  }

}