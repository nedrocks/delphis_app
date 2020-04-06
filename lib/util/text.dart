import 'package:flutter/material.dart';

List<TextBox> calculateTextLayoutRows(BuildContext context, BoxConstraints constraints, double horizontalPadding, String text) {
  final richTextWidget = Text.rich(TextSpan(text: text, style: DefaultTextStyle.of(context).style)).build(context) as RichText;
  final renderObject = richTextWidget.createRenderObject(context);
  var updatedWidth = constraints.maxWidth - horizontalPadding;
  final updatedConstraints = constraints.copyWith(maxWidth: updatedWidth, minWidth: updatedWidth);
  renderObject.layout(updatedConstraints);
  return renderObject.getBoxesForSelection(
    TextSelection(
      baseOffset: 0, 
      extentOffset: text.length
    )
  );
}