import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DelphisRichText extends StatelessWidget {
  final Map<RegExp, TextStyle Function(TextStyle)> regexPatternStyle = {};
  final String text;
  final TextStyle style;

  DelphisRichText({Key key, this.text, this.style}) : super(key: key);

  List<TextSpan> generateTextSpans(String text, TextStyle style) {
    List<TextSpan> children = [];
    RegExp allRegex = RegExp(regexPatternStyle.keys.map((e) => e.pattern.toString()).join('|'));

    text.splitMapJoin(
      allRegex,
      onMatch: (Match m) {
        var func = regexPatternStyle.entries.firstWhere((e) => e.key.hasMatch(m[0]), orElse: () => null)?.value ?? (t) => t;
        var curStyle = func(style);
        children.add(
          TextSpan(
            text: m[0],
            style: curStyle,
          ),
        );
        return m[0];
      },
      onNonMatch: (String span) {
        children.add(TextSpan(text: span, style: style));
        return span.toString();
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
