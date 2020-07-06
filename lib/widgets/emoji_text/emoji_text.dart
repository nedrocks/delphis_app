import 'package:flutter/material.dart';

import 'package:delphis_app/widgets/delphis_rich_text/delphis_rich_text.dart';

class EmojiText extends DelphisRichText {
  static final regex = RegExp(
      "((?:\u00a9|\u00ae|[\u2000-\u3300]|\ufe0f|[\ud83c-\ud83e][\udc00-\udfff]|\udb40[\udc61-\udc7f])+)");
  final double emojiFontMultiplier;
    
  EmojiText({
    text,
    style,
    this.emojiFontMultiplier = 1.3
  }) : super(text: text, style: style) {
    this.setStyleOperator(regex.pattern, this.styleFunction);
  }

  TextStyle styleFunction(TextStyle s, String a, String b) {
    return s.copyWith(
      fontSize: (s.fontSize * emojiFontMultiplier),
      letterSpacing: 2,
      height: 1.3333,
    );
  }

}
