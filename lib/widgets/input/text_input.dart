import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DelphisTextInput extends StatelessWidget {
  final TextEditingController controller;
  int numRows;
  final double borderRadius;
  final double verticalPadding;
  final double height;
  final FocusNode focusNode;
  final String hintText;

  DelphisTextInput({
    this.controller,
    this.numRows,
    this.borderRadius,
    this.height,
    this.focusNode,
    this.verticalPadding,
    this.hintText,
  }): super();

  @override
  Widget build(BuildContext context) {
    var style = DefaultTextStyle.of(context).style.copyWith(color: Color.fromRGBO(195, 195, 195, 1.0));
    return Container(
      height: this.height,
      child: TextField(
        controller: this.controller,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: this.borderRadius/2.0, vertical: this.verticalPadding),
          hintStyle: style,
          hintText: this.hintText,
          isDense: true,
          fillColor: Color.fromRGBO(31, 31, 31, 1.0),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(this.borderRadius),
          ),
        ),
        keyboardType: TextInputType.multiline,
        maxLines: this.numRows,
      ),
    );
  }
}