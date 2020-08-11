import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MuteConfirmationDialog extends StatefulWidget {
  final Function(int) onConfirm;

  const MuteConfirmationDialog({
    Key key,
    @required this.onConfirm,
  }) : super(key: key);

  @override
  _MuteConfirmationDialogState createState() => _MuteConfirmationDialogState();
}

class _MuteConfirmationDialogState extends State<MuteConfirmationDialog> {
  int _currentValue;

  @override
  void initState() {
    _currentValue = _currentValue = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      insetAnimationCurve: Curves.easeInOut,
      insetAnimationDuration: Duration(milliseconds: 200),
      title: Container(
        margin: EdgeInsets.only(bottom: SpacingValues.smallMedium),
        child: Text(Intl.message("Muting Details"),
            style: TextThemes.goIncognitoHeader),
      ),
      content: Column(
        children: <Widget>[
          Text(
            "Please choose for how many hours you prefer this participant to stay muted.",
            style: TextThemes.goIncognitoOptionName.copyWith(height: 1.25),
          ),
          SizedBox(height: SpacingValues.mediumLarge),
          Material(
            color: Colors.transparent,
            child: Slider(
              value: _currentValue.toDouble(),
              min: 1,
              max: 24,
              divisions: 24,
              label: _currentValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currentValue = value.round();
                });
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text(Intl.message("Cancel")),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            }),
        CupertinoDialogAction(
          child: Text(Intl.message("Continue")),
          onPressed: () {
            this.widget.onConfirm(_currentValue * 3600);
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }
}
