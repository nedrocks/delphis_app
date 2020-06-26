import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DelphisRichText extends StatelessWidget {
  final Map<RegExp, TextStyle Function(TextStyle)> regexPatternStyle = {};
  final Map<RegExp, String Function(String)> regexPatternText = {};
  final String text;
  final TextStyle style;

  DelphisRichText({Key key, this.text, this.style}) : super(key: key);

  List<TextSpan> generateTextSpans(String text, TextStyle style) {
    List<TextSpan> children = [];
    String allPatterns = '';
    allPatterns += regexPatternStyle.keys.map((e) => e.pattern.toString()).join('|');
    allPatterns += "|" + regexPatternText.keys.map((e) => e.pattern.toString()).join('|');
    RegExp allRegex = RegExp(allPatterns);

    text.splitMapJoin(
      allRegex,
      onMatch: (Match m) {
        var styleFunc = regexPatternStyle.entries.firstWhere((e) => e.key.hasMatch(m[0]), orElse: () => null)?.value ?? (t) => t;
        var textFunc = regexPatternText.entries.firstWhere((e) => e.key.hasMatch(m[0]), orElse: () => null)?.value ?? (t) => t;
        var curStyle = styleFunc(style);
        var curText = textFunc(m[0]);
        children.add(
          TextSpan(
            text: curText,
            style: curStyle,
          ),
        );
        return curText;
      },
      onNonMatch: (String span) {
        children.add(TextSpan(text: span, style: style));
        return span;
      },
    );
    return children;
  }

  @override
  Widget build(BuildContext context) {
    var curStyle = this.style ?? DefaultTextStyle.of(context).style;
    return Container(
      child: RichText(
        text: TextSpan(children: generateTextSpans(text, curStyle), style: curStyle),
      ),
    );
  }
  
}
