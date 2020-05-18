import 'dart:math';

import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/bloc/me/me_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/util/text.dart';
import 'package:delphis_app/widgets/input/discussion_submit_button.dart';
import 'package:delphis_app/widgets/input/moderator_input_button.dart';
import 'package:delphis_app/widgets/settings/participant_settings_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

const MAX_VISIBLE_ROWS = 5;

class DelphisInput extends StatefulWidget {
  final Discussion discussion;
  final Participant participant;
  final bool isShowingParticipantSettings;
  final VoidCallback onParticipantSettingsPressed;
  final ScrollController parentScrollController;

  DelphisInput({
    @required this.discussion,
    @required this.participant,
    @required this.isShowingParticipantSettings,
    @required this.onParticipantSettingsPressed,
    this.parentScrollController,
  });

  State<StatefulWidget> createState() => DelphisInputState();
}

class DelphisInputState extends State<DelphisInput> {
  double _borderRadius = 25.0;
  double _textBoxVerticalPadding = 26.0;
  int _textLength = 0;

  String _fullText;

  TextEditingController _controller;
  FocusNode _inputFocusNode;
  GlobalKey _textInputKey;
  TextField _input;
  VoidCallback _currentScrollListener;
  double _scrollStart;

  @override
  void initState() {
    super.initState();

    this._fullText = "";

    this._controller = TextEditingController();
    this._controller.addListener(() => this.setState(() {
          this._textLength = this._controller.text.length;
        }));
    this._inputFocusNode = FocusNode();
    this._inputFocusNode.addListener(() {
      if (this._inputFocusNode.hasFocus) {
        this._controller.selection = TextSelection.fromPosition(
            TextPosition(offset: this._controller.text.length));
      }
    });
    this._textInputKey = GlobalKey();
    this._inputFocusNode.addListener(() {
      if (this._inputFocusNode.hasFocus) {
        this._controller.text = this._fullText;
        this._scrollStart = this.widget.parentScrollController.position.pixels;
        this.widget.parentScrollController.addListener(this.scrollListener);
      } else {
        this._fullText = this._controller.text;
        this.widget.parentScrollController.removeListener(this.scrollListener);
      }
    });
  }

  void scrollListener() {
    if (this.widget.parentScrollController.position.pixels - this._scrollStart >
        80.0) {
      this._inputFocusNode.unfocus();
    }
  }

  @override
  void dispose() {
    this._inputFocusNode.dispose();
    this._controller.dispose();
    super.dispose();
  }

  List<Widget> buildNonInputRowElems(BuildContext context, MeState state,
      User me, bool isModerator, Widget textInput) {
    final rowElems = <Widget>[
      ParticipantSettingsButton(
        onPressed: this.widget.onParticipantSettingsPressed,
        me: me,
        isModerator: isModerator,
        participant: this.widget.participant,
        width: 39.0,
        height: 39.0,
      ),
      SizedBox(
        width: SpacingValues.medium,
      ),
      textInput,
    ];
    if (isModerator) {
      rowElems.add(SizedBox(
        width: SpacingValues.small,
      ));
      rowElems.add(ModeratorInputButton(
        onPressed: () {
          print('inputButtonPressed');
        },
        height: 39.0,
        width: 39.0,
      ));
    }
    return rowElems;
  }

  List<Widget> buildInputRowElems(BuildContext context, MeState state, User me,
      bool isModerator, Widget textInput) {
    final rowElems = <Widget>[
      textInput,
      SizedBox(
        width: SpacingValues.medium,
      ),
      DiscussionSubmitButton(
        onPressed: () {
          BlocProvider.of<DiscussionBloc>(context).add(
            DiscussionPostAddEvent(postContent: this._controller.text),
          );
          this._controller.text = '';
        },
        width: 40.0,
        height: 40.0,
        isActive: this._controller.text.length > 0,
      ),
    ];
    return rowElems;
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
        var lineHeight = textStyle.height;
        var text =
            this._controller.text.length == 0 ? ' ' : this._controller.text;
        List<TextBox> textLayout = calculateTextLayoutRows(
            context, constraints, this._borderRadius, text);
        // TODO: We probably want to add ellipsis when the text is truncated (i.e. no focus and
        // the text would be more than 1 row.) This will require storing the text contents
        // in another place when we lose focus.
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
        var isEnabled = !this.widget.isShowingParticipantSettings;
        final hintStyle =
            textStyle.copyWith(color: Color.fromRGBO(81, 82, 88, 1.0));

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
            child: this._input = TextField(
              key: this._textInputKey,
              enabled: isEnabled,
              showCursor: true,
              focusNode: this._inputFocusNode,
              controller: this._controller,
              style: textStyle,
              decoration: InputDecoration(
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
            ),
          ),
          height: widgetHeight,
        );
      });

      Expanded textInput = Expanded(
        child: inputChild,
      );
      final rowElems = this._inputFocusNode.hasFocus
          ? this.buildInputRowElems(context, state, me, isModerator, textInput)
          : this.buildNonInputRowElems(
              context, state, me, isModerator, textInput);
      return ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: 60.0,
          maxHeight: 200.0,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.black),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SpacingValues.medium,
                vertical: SpacingValues.medium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: rowElems,
            ),
          ),
        ),
      );
    });
  }
}
