import 'dart:io';
import 'dart:math';

import 'package:delphis_app/bloc/me/me_bloc.dart';
import 'package:delphis_app/bloc/superpowers/superpowers_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/util/text.dart';
import 'package:delphis_app/widgets/input/buttons/discussion_submit_button.dart';
import 'package:delphis_app/widgets/input/buttons/moderator_action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'buttons/camera_picker_button.dart';
import 'buttons/gallery_picker_button.dart';
import 'buttons/mention_button.dart';

const MAX_VISIBLE_ROWS = 5;

class DelphisInput extends StatefulWidget {
  final Discussion discussion;
  final Participant participant;
  final bool isModeratorButtonEnabled;
  final ScrollController parentScrollController;
  final TextEditingController textController;
  final FocusNode inputFocusNode;
  final Function(String) onSubmit;
  final VoidCallback onVideoCameraPressed;
  final VoidCallback onImageCameraPressed;
  final VoidCallback onGalleryPressed;
  final VoidCallback onParticipantMentionPressed;
  final VoidCallback onDiscussionMentionPressed;
  final VoidCallback onModeratorButtonPressed;
  final File mediaFile;

  DelphisInput({
    @required this.discussion,
    @required this.participant,
    @required this.onSubmit,
    this.inputFocusNode,
    this.textController,
    this.parentScrollController,
    this.onVideoCameraPressed,
    this.onImageCameraPressed,
    this.onGalleryPressed,
    this.onParticipantMentionPressed,
    this.onDiscussionMentionPressed,
    this.onModeratorButtonPressed,
    this.isModeratorButtonEnabled = true,
    this.mediaFile,
  });

  State<StatefulWidget> createState() => DelphisInputState();
}

class DelphisInputState extends State<DelphisInput> {
  final maxTextLength = 4096;
  final imagePicker = ImagePicker();
  final GlobalKey _textInputKey = GlobalKey();
  double _borderRadius = 25.0;
  double _textBoxVerticalPadding = 26.0;
  TextEditingController _controller;
  FocusNode _inputFocusNode;
  double _scrollStart;

  String _fullText;

  @override
  void initState() {
    this._fullText = "";

    this._controller = this.widget.textController ?? TextEditingController();
    this._inputFocusNode = this.widget.inputFocusNode ?? FocusNode();
    this._inputFocusNode.addListener(() {
      if (this._inputFocusNode.hasFocus) {
        this._controller.selection = TextSelection.fromPosition(
            TextPosition(offset: this._controller.text.length));
      }
    });

    this._inputFocusNode.addListener(() {
      if (this._inputFocusNode.hasFocus) {
        this._controller.text = this._fullText;
        this._scrollStart = this.widget.parentScrollController.position.pixels;
        this.widget.parentScrollController.addListener(this.scrollListener);
      } else {
        this.widget.parentScrollController.removeListener(this.scrollListener);
      }
    });

    /* Forces a rebuild everytime the focus/text changes.
       This is needed as the UI changes depending on
       the text input focus */
    this._inputFocusNode.addListener(() {
      setState(() {});
    });
    this._controller.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  void scrollListener() {
    if (this.widget.parentScrollController.position.pixels - this._scrollStart >
        80.0) {
      this._inputFocusNode.unfocus();
    }
  }

  @override
  void dispose() {
    if (this._inputFocusNode != this.widget.inputFocusNode)
      this._inputFocusNode.dispose();
    if (this._controller != this.widget.textController)
      this._controller.dispose();
    super.dispose();
  }

  Widget buildLockedInputRowElems(BuildContext context) {
    return Container(
      child: RaisedButton(
        onPressed: () {
          BlocProvider.of<SuperpowersBloc>(context).add(ChangeLockStatusEvent(
              discussion: this.widget.discussion, isLock: false));
        },
        padding: EdgeInsets.symmetric(
          horizontal: SpacingValues.xxxxLarge,
          vertical: SpacingValues.medium,
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        color: Color.fromRGBO(247, 247, 255, 0.2),
        child: Text(Intl.message("Unlock Discussion"),
            style: TextThemes.errorButtonCancel),
        animationDuration: Duration(milliseconds: 100),
      ),
    );
  }

  List<Widget> buildNonInputRowElems(BuildContext context, MeState state,
      User me, bool isModerator, Widget textInput) {
    if (this.widget.discussion.meParticipant.isMuted) {
      var until = this.widget.discussion.meParticipant.mutedUntil;
      var untilText = Intl.message(
          "${DateFormat.yMd().format(until)} at ${DateFormat.Hm().format(until)}");
      textInput = Flexible(
        child: Text(
          Intl.message(
              "You have been muted by the moderator and will not be able to post until $untilText."),
          textAlign: TextAlign.center,
          style: TextThemes.discussionPostInput,
        ),
      );
    }
    final rowElems = <Widget>[
      textInput,
    ];
    if (isModerator && this.widget.isModeratorButtonEnabled) {
      rowElems.add(SizedBox(
        width: SpacingValues.small,
      ));
      rowElems.add(ModeratorActionButton(
        onPressed: this.widget.onModeratorButtonPressed,
        height: 36.0,
        width: 36.0,
        isActive: true,
      ));
    }
    return rowElems;
  }

  Widget buildInput(BuildContext context, MeState state, User me,
      bool isModerator, Widget textInput) {
    if (this.widget.discussion.meParticipant.isMuted) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              buildNonInputRowElems(context, state, me, isModerator, textInput),
        ),
      );
    }
    final actionIconSize = 36.0;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: buildNonInputRowElems(
                context, state, me, isModerator, textInput),
          ),
          SizedBox(
            height: SpacingValues.medium,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /* Action bar */
              Row(
                children: [
                  MentionButton(
                      onPressed: this.widget.onParticipantMentionPressed,
                      width: actionIconSize,
                      height: actionIconSize,
                      isActive: true,
                      isDiscussion: false),
                  SizedBox(
                    width: SpacingValues.medium,
                  ),
                  GalleryPickerButton(
                    onPressed: this.widget.onGalleryPressed,
                    width: actionIconSize,
                    height: actionIconSize,
                    isActive: true,
                  ),
                  SizedBox(
                    width: SpacingValues.medium,
                  ),
                  CameraPickerButton(
                    onPressed: this.widget.onImageCameraPressed,
                    width: actionIconSize,
                    height: actionIconSize,
                    isActive: true,
                    isVideo: false,
                  ),
                  SizedBox(
                    width: SpacingValues.medium,
                  ),
                ],
              ),

              /* Submit button */
              DiscussionSubmitButton(
                onPressed: () {
                  if (this.widget.onSubmit != null)
                    this.widget.onSubmit(_controller.text);
                  return true;
                },
                width: actionIconSize,
                height: actionIconSize,
                isActive: this._controller.text.isNotEmpty ||
                    this.widget.mediaFile != null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isModerator(User me) =>
      this.widget.discussion.moderator.userProfile.id == me.profile.id;

  void _truncateTextAndAddEllipses(
      BuildContext context, BoxConstraints constraints) {
    final text = this._fullText;
    var top = text.length;
    var bottom = 0;
    var curr = top;
    var textLayout = calculateTextLayoutRows(
        context, constraints, this._borderRadius, text.substring(0, curr));
    while (true) {
      if (top - bottom < 2 ||
          (textLayout.length == 2 &&
              textLayout[1].right - textLayout[1].left < 5)) {
        break;
      }
      if (textLayout.length == 1) {
        bottom = curr;
      } else {
        top = curr;
      }
      curr = ((top + bottom) / 2).round();
      textLayout = calculateTextLayoutRows(
          context, constraints, this._borderRadius, text.substring(0, curr));
    }

    this._controller.text =
        this._fullText.substring(0, max(curr - 3, 0)) + "...";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeBloc, MeState>(builder: (context, state) {
      if (!(state is LoadedMeState) || (state as LoadedMeState).me == null) {
        return Container(width: 0, height: 0);
      }
      final me = (state as LoadedMeState).me;

      final isModerator = this._isModerator(me);

      final inputChild = LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var textStyle = Theme.of(context).textTheme.bodyText2;
        var lineHeight = textStyle.height == null ? 1.0 : textStyle.height;
        var text =
            this._controller.text.length == 0 ? ' ' : this._controller.text;
        List<TextBox> textLayout = calculateTextLayoutRows(
            context, constraints, this._borderRadius, text);
        var numRows = this._inputFocusNode.hasFocus
            ? min(max(1, textLayout.length), MAX_VISIBLE_ROWS)
            : 1;
        if (textLayout.length > 1 && !this._inputFocusNode.hasFocus) {
          // Truncate the text and show ellipses.
          SchedulerBinding.instance.addPostFrameCallback((_) {
            this._truncateTextAndAddEllipses(context, constraints);
          });
        }
        var widgetHeight = numRows * lineHeight * textStyle.fontSize +
            this._textBoxVerticalPadding;
        var isEnabled = true;
        final hintStyle =
            textStyle.copyWith(color: Color.fromRGBO(81, 82, 88, 1.0));

        /* Change fulltext state only when building and having focus */
        if (this._inputFocusNode.hasFocus) {
          this._fullText = this._controller.text;
        }

        return Container(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onVerticalDragEnd: (details) {
              if (details == null) {
                return true;
              }
              if (details.primaryVelocity >= 150.0) {
                FocusScope.of(context).unfocus();
                return true;
              }
              return true;
            },
            child: TextField(
              key: this._textInputKey,
              enabled: isEnabled,
              showCursor: true,
              focusNode: this._inputFocusNode,
              controller: this._controller,
              style: textStyle,
              decoration: InputDecoration(
                counterStyle: TextStyle(
                  height: double.minPositive,
                ),
                counterText: "",
                contentPadding: EdgeInsets.symmetric(
                    horizontal: this._borderRadius / 2.0,
                    vertical: this._textBoxVerticalPadding / 2.0),
                hintStyle: hintStyle,
                hintText: Intl.message("Type a message"),
                fillColor: Color.fromRGBO(57, 58, 63, 0.4),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(this._borderRadius),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(this._borderRadius),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(this._borderRadius),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: numRows,
              maxLength: maxTextLength,
              maxLengthEnforced: true,
              autocorrect: true,
              enableSuggestions: true,
            ),
          ),
          height: widgetHeight,
        );
      });

      Expanded textInput = Expanded(
        child: inputChild,
      );
      return ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: 60.0,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.black),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SpacingValues.medium,
                vertical: SpacingValues.medium),
            child: !this._inputFocusNode.hasFocus
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: this.buildNonInputRowElems(
                        context, state, me, isModerator, textInput),
                  )
                : this.buildInput(context, state, me, isModerator, textInput),
          ),
        ),
      );
    });
  }
}
