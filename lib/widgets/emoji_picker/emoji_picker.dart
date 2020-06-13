import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChathamEmojiPicker extends StatelessWidget {
  final String selectedEmoji;
  final VoidCallback onPressed;

  final double width;
  final double height;

  const ChathamEmojiPicker({
    @required this.selectedEmoji,
    @required this.onPressed,
    @required this.width,
    @required this.height,
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
        this.onPressed();
      },
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(this.selectedEmoji,
                style: TextStyle(fontSize: this.height * 2 / 3 * 0.7)),
            Text(Intl.message('Pick an emoji or photo'),
                style: TextThemes.emojiPickerText),
          ],
        ),
      ),
    );
  }
}
