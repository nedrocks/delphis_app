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
  final values = {
    Intl.message("30 Minutes"): Duration(minutes: 30).inSeconds,
    Intl.message("1 Hour"): Duration(hours: 1).inSeconds,
    Intl.message("2 Hours"): Duration(hours: 2).inSeconds,
    Intl.message("6 Hours"): Duration(hours: 6).inSeconds,
    Intl.message("12 Hours"): Duration(hours: 12).inSeconds,
    Intl.message("1 Day"): Duration(days: 1).inSeconds,
  };
  List<String> keys;

  @override
  void initState() {
    keys = values.keys.toList();
    _currentValue = _currentValue = values[keys[0]];
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
          CupertinoPicker(
            itemExtent: 48,
            onSelectedItemChanged: (int index) {
              setState(() {
                _currentValue = values[keys[index]];
              });
            },
            children: List<Widget>.generate(
              keys.length,
              (int index) {
                return Center(
                  child: Text(
                    keys[index],
                    style: TextThemes.discussionPostText.copyWith(
                      color: Colors.blue,
                    ),
                  ),
                );
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
            this.widget.onConfirm(_currentValue);
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }
}
