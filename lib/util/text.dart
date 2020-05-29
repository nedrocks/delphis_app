import 'dart:math';

import 'package:flutter/material.dart';

List<TextBox> calculateTextLayoutRows(BuildContext context,
    BoxConstraints constraints, double horizontalPadding, String text) {
  final richTextWidget =
      Text.rich(TextSpan(text: text, style: DefaultTextStyle.of(context).style))
          .build(context) as RichText;
  final renderObject = richTextWidget.createRenderObject(context);
  var updatedWidth = constraints.maxWidth - horizontalPadding;
  final updatedConstraints =
      constraints.copyWith(maxWidth: updatedWidth, minWidth: updatedWidth);
  renderObject.layout(updatedConstraints);
  final textBoxes = renderObject.getBoxesForSelection(
      TextSelection(baseOffset: 0, extentOffset: text.length));
  // This is slightly annoying -- if characters have different heights but are on the same line
  // this function actually returns multiple text boxes.
  final List<TextBox> outputTextBoxes = List<TextBox>();
  for (var textBox in textBoxes) {
    final lastTextBox =
        outputTextBoxes.length > 0 ? outputTextBoxes.last : null;
    if (lastTextBox == null) {
      outputTextBoxes.add(textBox);
    } else {
      if ((textBox.top - lastTextBox.top).abs() <
              (lastTextBox.bottom - lastTextBox.top) * 0.4 &&
          textBox.left - lastTextBox.right < 0.01) {
        outputTextBoxes.removeLast();
        outputTextBoxes.add(TextBox.fromLTRBD(
            lastTextBox.left,
            min(lastTextBox.top, textBox.top),
            textBox.right,
            max(lastTextBox.bottom, textBox.bottom),
            lastTextBox.direction));
      } else {
        outputTextBoxes.add(textBox);
      }
    }
  }
  return outputTextBoxes;
}
