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
  final TextStyle textStyle;
  bool isEnabled;

  DelphisTextInput({
    @required this.controller,
    @required this.numRows,
    @required this.borderRadius,
    @required this.height,
    @required this.focusNode,
    @required this.verticalPadding,
    @required this.hintText,
    @required this.textStyle,
    @required this.isEnabled,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final hintStyle =
        this.textStyle.copyWith(color: Color.fromRGBO(81, 82, 88, 1.0));
    final textField = TextField(
      enabled: this.isEnabled,
      showCursor: true,
      focusNode: this.focusNode,
      controller: this.controller,
      style: this.textStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            horizontal: this.borderRadius / 2.0,
            vertical: this.verticalPadding),
        hintStyle: hintStyle,
        hintText: this.hintText,
        fillColor: Color.fromRGBO(57, 58, 63, 0.4),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(this.borderRadius),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(this.borderRadius),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(this.borderRadius),
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
      keyboardType: TextInputType.multiline,
      maxLines: this.numRows,
    );
    return Container(
      height: this.height,
      child: textField,
    );
  }
}
