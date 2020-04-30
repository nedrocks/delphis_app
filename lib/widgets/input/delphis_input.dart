import 'dart:math';

import 'package:delphis_app/bloc/discussion_post/discussion_post_bloc.dart';
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

import 'text_input.dart';

const MAX_VISIBLE_ROWS = 5;

class DelphisInput extends StatefulWidget {
  final Discussion discussion;
  final Participant participant;

  DelphisInput({
    @required this.discussion,
    @required this.participant,
  });

  State<StatefulWidget> createState() => DelphisInputState();
}

class DelphisInputState extends State<DelphisInput> {
  double _borderRadius = 25.0;
  double _textBoxVerticalPadding = 26.0;
  int _textLength = 0;

  TextEditingController _controller;
  FocusNode _inputFocusNode;

  @override
  void initState() {
    super.initState();

    this._controller = TextEditingController();
    this._controller.addListener(() =>
        this.setState(() => {this._textLength = this._controller.text.length}));
    this._inputFocusNode = FocusNode();
    this._inputFocusNode.addListener(() {
      if (this._inputFocusNode.hasFocus) {
        print('received focus');
        this._controller.selection = TextSelection.fromPosition(
            TextPosition(offset: this._controller.text.length));
        this._inputFocusNode.consumeKeyboardToken();
      } else {
        print('lost focus');
      }
    });
  }

  @override
  void dispose() {
    this._inputFocusNode.dispose();
    this._controller.dispose();
    super.dispose();
  }

  User _extractMe(MeState state) {
    if (state is LoadedMeState) {
      return state.me;
    } else {
      // This should never happen and we should probably throw an error here?
      return null;
    }
  }

  List<Widget> buildNonInputRowElems(BuildContext context, MeState state,
      User me, bool isModerator, Widget textInput) {
    final rowElems = <Widget>[
      ParticipantSettingsButton(
        onClick: () {
          // BlocProvider.of<DiscussionPostBloc>(context).add(
          //   DiscussionPostAddEvent(postContent: this._controller.text),
          // );
          // this._controller.text = "";
          // TODO: This should open up anonymity options.
        },
        discussion: this.widget.discussion,
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
          BlocProvider.of<DiscussionPostBloc>(context).add(
            DiscussionPostAddEvent(postContent: this._controller.text),
          );
          this._controller.text = '';
          SchedulerBinding.instance.addPostFrameCallback((_) {
            setState(() {
              this._inputFocusNode.unfocus();
            });
          });
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

  @override
  Widget build(BuildContext context) {
    final me = this._extractMe(BlocProvider.of<MeBloc>(context).state);
    if (me == null) {
      return Container(width: 0, height: 0);
    }
    final isModerator = this._isModerator(me);
    return BlocBuilder<MeBloc, MeState>(builder: (context, state) {
      if (!(state is LoadedMeState)) {
        return Text("Loading");
      }
      final textInput = Expanded(
        child: GestureDetector(
          onTap: () {
            this._inputFocusNode.requestFocus()
          },
          onDoubleTap: () {
            this._inputFocusNode.unfocus();
          },
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            var textStyle = Theme.of(context).textTheme.bodyText2;
            var lineHeight = textStyle.height;
            var text =
                this._controller.text.length == 0 ? ' ' : this._controller.text;
            List<TextBox> textLayout = calculateTextLayoutRows(
                context, constraints, this._borderRadius, text);
            var widgetHeight = min(textLayout.length, MAX_VISIBLE_ROWS) *
                    lineHeight *
                    textStyle.fontSize +
                this._textBoxVerticalPadding;

            return DelphisTextInput(
              controller: this._controller,
              numRows: min(max(1, textLayout.length), MAX_VISIBLE_ROWS),
              borderRadius: this._borderRadius,
              focusNode: this._inputFocusNode,
              height: widgetHeight,
              verticalPadding: this._textBoxVerticalPadding / 2.0,
              hintText: Intl.message("Type a message"),
              textStyle: textStyle,
            );
          }),
        ),
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
