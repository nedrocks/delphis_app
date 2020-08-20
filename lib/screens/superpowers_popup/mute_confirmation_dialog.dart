import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MuteConfirmationDialog extends StatefulWidget {
  final Function(int) onConfirm;
  final bool isShuffle;

  const MuteConfirmationDialog({
    Key key,
    @required this.onConfirm,
    this.isShuffle = false,
  }) : super(key: key);

  @override
  _MuteConfirmationDialogState createState() => _MuteConfirmationDialogState();
}

class _MuteConfirmationDialogState extends State<MuteConfirmationDialog> {
  int _currentValue;

  @override
  void initState() {
    _currentValue = _currentValue = this.widget.isShuffle ? 0 : 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      insetAnimationCurve: Curves.easeInOut,
      insetAnimationDuration: Duration(milliseconds: 200),
      title: Container(
        margin: EdgeInsets.only(bottom: SpacingValues.smallMedium),
        child: Text(
            this.widget.isShuffle
                ? Intl.message("Shuffle Aliases")
                : Intl.message("Muting Details"),
            style: TextThemes.goIncognitoHeader),
      ),
      content: Column(
        children: <Widget>[
          Text(
            this.widget.isShuffle
                ? "In how many hours do you want to shuffle?"
                : "Please choose for how many hours you prefer this participant to stay muted.",
            style: TextThemes.goIncognitoOptionName.copyWith(height: 1.25),
          ),
          SizedBox(height: SpacingValues.mediumLarge),
          Text(
              this.widget.isShuffle
                  ? (_currentValue <= 0
                      ? "Shuffle now"
                      : "Shuffle in: $_currentValue hours")
                  : "Mute for $_currentValue hours",
              style: TextThemes.goIncognitoOptionName.copyWith(height: 1.25)),
          Material(
            color: Colors.transparent,
            child: Slider(
              value: _currentValue.toDouble(),
              min: this.widget.isShuffle ? 0 : 1,
              max: this.widget.isShuffle ? 72 : 24,
              divisions: this.widget.isShuffle ? 12 : 24,
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
