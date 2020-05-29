import 'package:flutter/material.dart';

// NOTE: This came from https://github.com/flutter/flutter/issues/28894
class EmojiText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double emojiFontMultiplier;

  const EmojiText({
    @required this.text,
    @required this.style,
    this.emojiFontMultiplier = 1.3, // Decrease by 25%
  });

  // Regex to match emojis
  static final regex = RegExp(
      "((?:\u00a9|\u00ae|[\u2000-\u3300]|\ufe0f|[\ud83c-\ud83e][\udc00-\udfff]|\udb40[\udc61-\udc7f])+)");

  List<TextSpan> generateTextSpans(String text) {
    List<TextSpan> spans = [];
    final TextStyle emojiStyle = style.copyWith(
      fontSize: (style.fontSize * emojiFontMultiplier),
      letterSpacing: 2,
      height: 1.3333,
    );

    text.splitMapJoin(
      regex,
      onMatch: (m) {
        spans.add(
          TextSpan(
            text: m.group(0),
            style: emojiStyle,
          ),
        );
        return "";
      },
      onNonMatch: (s) {
        spans.add(TextSpan(text: s));
        return "";
      },
    );
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        text: TextSpan(children: generateTextSpans(text), style: style),
      ),
    );
  }
}
