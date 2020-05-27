import 'dart:math';

import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';

class AdditionalParticipants extends StatelessWidget {
  final double diameter;
  final int numAdditional;

  const AdditionalParticipants({
    Key key,
    @required this.diameter,
    @required this.numAdditional,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.numAdditional == 0) {
      return Container(
          key: this.key == null
              ? null
              : Key('${this.key.toString()}-participant-container'),
          width: 0,
          height: 0);
    }
    return Container(
      key: this.key == null
          ? key
          : Key('${this.key.toString()}-participant-container'),
      width: this.diameter,
      height: this.diameter,
      decoration: BoxDecoration(
        color: Color.fromRGBO(62, 62, 76, 1.0),
        shape: BoxShape.circle,
      ),
      alignment: Alignment(-0.1, 0.0),
      child: RichText(
        text: TextSpan(
          children: <InlineSpan>[
            TextSpan(
                text: '+',
                style: TextThemes.discussionAdditionalParticipantsPlusSign),
            TextSpan(
                text: max(0, min(99, numAdditional)).toString(),
                style: TextThemes.discussionAdditionalParticipants),
          ],
        ),
      ),
    );
  }
}
