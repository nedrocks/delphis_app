import 'package:flutter/material.dart';

List<TextBox> calculateTextLayoutRows(BuildContext context, BoxConstraints constraints, String text) {
  final richTextWidget = Text.rich(TextSpan(text: text)).build(context) as RichText;
  final renderObject = richTextWidget.createRenderObject(context);
  renderObject.layout(constraints);
  return renderObject.getBoxesForSelection(
    TextSelection(
      baseOffset: 0, 
      extentOffset: text.length
    )
  );
}