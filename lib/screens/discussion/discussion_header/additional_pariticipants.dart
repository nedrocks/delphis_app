import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';

class AdditionalParticipants extends StatelessWidget {
  final double diameter;
  final int numAdditional;

  const AdditionalParticipants({
    @required this.diameter,
    @required this.numAdditional,
  }): super();

  @override
  Widget build(BuildContext context) {
    return Container(
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
            TextSpan(text: '+', style: TextThemes.discussionAdditionalParticipantsPlusSign),
            TextSpan(text: numAdditional.toString(), style: TextThemes.discussionAdditionalParticipants),
          ],
        ),
      ),
    );
  }
}