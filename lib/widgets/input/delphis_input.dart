import 'dart:math';

import 'package:delphis_app/util/text.dart';
import 'package:flutter/material.dart';

import 'input_button.dart';
import 'text_input.dart';

class DelphisInput extends StatefulWidget {
  State<StatefulWidget> createState() => DelphisInputState();
}

class DelphisInputState extends State<DelphisInput> {
  TextEditingController _controller;
  FocusNode _inputFocusNode;

  double _height;

  @override
  void initState() {
    super.initState();

    this._controller = TextEditingController();
    this._inputFocusNode = FocusNode();
    this._height = 100;
  }

  @override
  void dispose() {
    this._inputFocusNode.dispose();
    this._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: this._height,
      color: Colors.black,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 25.0, top: 10.0, left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                var text = this._controller.text.length == 0 ? ' ' : this._controller.text;
                List<TextBox> textLayout = calculateTextLayoutRows(context, constraints, text);
                var singleRowHeightPixels = textLayout[0].bottom - textLayout[0].top;
                // no idea -- total guess.
                var padding = 80.0;
                var widgetHeight = textLayout.length * singleRowHeightPixels + padding;
                if (widgetHeight != this._height) {
                  this.setState(() => { this._height = widgetHeight });
                }
                return DelphisTextInput(
                  controller: this._controller,
                  numRows: max(1, textLayout.length),
                  focusNode: this._inputFocusNode,
                  height: widgetHeight,
                );
              }
            ),
            flex: 6,
          ),
          Flexible(
            child: DelphisInputButton(
              onClick: () => print('clicked'),
            ),
            flex: 1,
          ),
        ],
      )
    );
  }
}