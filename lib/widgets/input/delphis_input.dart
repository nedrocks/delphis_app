import 'dart:math';

import 'package:delphis_app/bloc/discussion_post/discussion_post_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/util/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'input_button.dart';
import 'text_input.dart';

const MAX_VISIBLE_ROWS = 5;

class DelphisInput extends StatefulWidget {
  final Discussion discussion;

  DelphisInput({
    @required this.discussion,
  });

  State<StatefulWidget> createState() => DelphisInputState();
}

class DelphisInputState extends State<DelphisInput> {

  double _borderRadius = 25.0;
  double _textBoxVerticalPadding = 26.0;
  int _textLength = 0;

  TextEditingController _controller;
  FocusNode _inputFocusNode;

  double _height;

  @override
  void initState() {
    super.initState();

    this._controller = TextEditingController();
    this._controller.addListener(() => this.setState(() => { 
      this._textLength = this._controller.text.length 
    }));
    this._inputFocusNode = FocusNode();
  }

  @override
  void dispose() {
    this._inputFocusNode.dispose();
    this._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: new BoxConstraints(
        minHeight: 60.0,
        maxHeight: 200.0,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.black),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SpacingValues.medium, vertical: SpacingValues.medium),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BlocBuilder<DiscussionPostBloc, DiscussionPostState>(
                builder: (context, state) {
                  return DelphisInputButton(
                    onClick: () {
                      BlocProvider.of<DiscussionPostBloc>(context).add(
                        DiscussionPostAddEvent(postContent: this._controller.text),
                      );
                      this._controller.text = "";
                    },
                    width: 39.0,
                    height: 39.0,
                  );
                }
              ),
              SizedBox(
                width: SpacingValues.medium,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    var textStyle = Theme.of(context).textTheme.bodyText2;
                    var lineHeight = textStyle.height;
                    var text = this._controller.text.length == 0 ? ' ' : this._controller.text;
                    List<TextBox> textLayout = calculateTextLayoutRows(context, constraints, this._borderRadius, text);
                    var widgetHeight = min(textLayout.length, MAX_VISIBLE_ROWS) * lineHeight * textStyle.fontSize + this._textBoxVerticalPadding;
                    
                    return DelphisTextInput(
                      controller: this._controller,
                      numRows: min(max(1, textLayout.length), MAX_VISIBLE_ROWS),
                      borderRadius: this._borderRadius,
                      focusNode: this._inputFocusNode,
                      height: widgetHeight,
                      verticalPadding: this._textBoxVerticalPadding/2.0,
                      hintText: Intl.message("Type a message"),
                      textStyle: textStyle,
                    );
                  }
                ),
                flex: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}