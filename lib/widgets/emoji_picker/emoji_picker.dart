import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ChathamEmojiPicker extends StatelessWidget {
  final double width;
  final double height;

  final FocusNode textFocusNode;
  final TextEditingController textController;
  final TextInputFormatter formatter;

  const ChathamEmojiPicker({
    @required this.width,
    @required this.height,
    @required this.textFocusNode,
    @required this.textController,
    @required this.formatter,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Pressable(
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        color: Color.fromRGBO(36, 37, 42, 1.0),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Color.fromRGBO(51, 51, 56, 1.0), width: 2.0),
      ),
      onPressed: () {
        this.textController.text = '';
        this.textFocusNode.requestFocus();
      },
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
                enabled: true,
                showCursor: false,
                focusNode: this.textFocusNode,
                controller: this.textController,
                keyboardType: TextInputType.text,
                inputFormatters: [this.formatter],
                maxLines: 1,
                decoration: InputDecoration(border: InputBorder.none),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: this.height * 2 / 3 * 0.7)),
            Text(Intl.message('Pick an emoji or photo'),
                style: TextThemes.emojiPickerText),
          ],
        ),
      ),
    );
  }
}
