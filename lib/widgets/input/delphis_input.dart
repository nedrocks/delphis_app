import 'package:flutter/material.dart';

import 'input_button.dart';
import 'text_input.dart';

class DelphisInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100.0,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 25.0, top: 10.0, left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: DelphisTextInput(),
            flex: 6,
          ),
          Flexible(
            child: DelphisInputButton(
              onClick: () => print('clicked'),
            ),
            flex: 1,
          ),
        ],
      )
    );
  }
}