import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class _MatchOp {
  TextStyle Function(TextStyle) style;
  String Function(String) text;
}

class DelphisTextEditingController extends TextEditingController {
  final Map<Pattern, _MatchOp> _regexPattern = {
    /* This is not really needed, however emojis causes a lot of exceptions
       if there is not at least one pattern in the map. */
    "test": _MatchOp(),
  };

  void setStyleOperator(Pattern pattern, TextStyle Function(TextStyle) op) {
    if (!_regexPattern.containsKey(pattern)) {
      _regexPattern[pattern] = _MatchOp();
    }
    _regexPattern[pattern].style = op;
  }

  void setTextOperator(Pattern pattern, String Function(String) op) {
    if (!_regexPattern.containsKey(pattern)) {
      _regexPattern[pattern] = _MatchOp();
    }
    _regexPattern[pattern].text = op;
  }

  @override
  TextSpan buildTextSpan({TextStyle style, bool withComposing}) {
    List<TextSpan> children = [];
    RegExp allRegex =
        RegExp(_regexPattern.keys.map((e) => e.toString()).join('|'));

    text.splitMapJoin(
      allRegex,
      onMatch: (Match m) {
        var matchOp = _regexPattern.entries
                .firstWhere((e) => RegExp(e.key).hasMatch(m[0]),
                    orElse: () => null)
                ?.value ??
            null;
        var curStyle = (matchOp?.style ?? (t) => t)(style);
        var curText = (matchOp?.text ?? (t) => t)(m[0]);
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
    return TextSpan(style: style, children: children);
  }
}
