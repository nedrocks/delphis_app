import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DelphisTextEditingController extends TextEditingController {
  final Map<RegExp, TextStyle Function(TextStyle)> regexPatternStyle = {};

  @override
  TextSpan buildTextSpan({TextStyle style, bool withComposing}) {
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
    return TextSpan(style: style, children: children);
  }

}