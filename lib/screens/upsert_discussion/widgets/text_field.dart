import 'package:flutter/material.dart';

class UpsertDiscussionTextField extends StatelessWidget {
  final String hint;
  final Function(String) onChanged;
  final TextEditingController textController;
  final int maxLines;
  final bool autofocus;
  final int maxLenght;
  final bool showLengthCounter;

  const UpsertDiscussionTextField({
    Key key,
    @required this.hint,
    this.onChanged,
    @required this.textController,
    this.maxLines = 1,
    this.autofocus = true,
    this.maxLenght = 50,
    this.showLengthCounter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.bodyText2;
    var hintStyle = textStyle.copyWith(color: Color.fromRGBO(81, 82, 88, 1.0));
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      maxLengthEnforced: true,
      autocorrect: true,
      enableSuggestions: true,
      autofocus: autofocus,
      showCursor: true,
      controller: this.textController,
      decoration: InputDecoration(
        counter: this.showLengthCounter ? null : Container(),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 13.0),
        hintStyle: hintStyle,
        hintText: this.hint,
        fillColor: Color.fromRGBO(57, 58, 63, 1.0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
      keyboardType: TextInputType.multiline,
      maxLines: this.maxLines,
      maxLength: maxLenght,
      onChanged: onChanged,
    );
  }
}
