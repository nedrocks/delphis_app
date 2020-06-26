import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class _MatchOp {
  TextStyle Function(TextStyle) style;
  String Function(String) text;
  void Function(String) onTap;
}

class DelphisRichText extends StatelessWidget {
  final Map<Pattern, _MatchOp> _regexPattern = {};
  final String text;
  final TextStyle style;

  DelphisRichText({Key key, this.text, this.style}) : super(key: key);

  void setStyleOperator(Pattern pattern, TextStyle Function(TextStyle) op) {
    if(!_regexPattern.containsKey(pattern)) {
     _regexPattern[pattern] = _MatchOp();
    }
    _regexPattern[pattern].style = op;
  }

  void setTextOperator(Pattern pattern, String Function(String) op) {
    if(!_regexPattern.containsKey(pattern)) {
     _regexPattern[pattern] = _MatchOp();
    }
    _regexPattern[pattern].text = op;
  }

  void setOnTap(Pattern pattern, void Function(String) op) {
    if(!_regexPattern.containsKey(pattern)) {
     _regexPattern[pattern] = _MatchOp();
    }
    _regexPattern[pattern].onTap = op;
  }

  List<TextSpan> generateTextSpans(String text, TextStyle style) {
    List<TextSpan> children = [];
    RegExp allRegex = RegExp(_regexPattern.keys.map((e) => e.toString()).join('|'));

    text.splitMapJoin(
      allRegex,
      onMatch: (Match m) {
        var matchOp = _regexPattern.entries.firstWhere((e) => RegExp(e.key).hasMatch(m[0]), orElse: () => null)?.value ?? null;
        var curStyle = (matchOp?.style ?? (t) => t)(style);
        var curText = (matchOp?.text ?? (t) => t)(m[0]);
        var onTap = matchOp?.onTap ?? (t) {};
        children.add(
          TextSpan(
            text: curText,
            style: curStyle,
            recognizer : TapGestureRecognizer()..onTap = () {
              onTap(curText);
              return true;
            }
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
