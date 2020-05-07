import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/discussion/overlay/participant_settings.dart';
import 'package:delphis_app/screens/discussion/overlay/participant_flair_selector_option.dart';
import 'package:delphis_app/widgets/go_back/go_back.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ParticipantFlairSettings extends StatefulWidget {
  final User user;
  final IDCallback onSave;
  final VoidCallback onCancel;
  final String selectedFlairID;

  const ParticipantFlairSettings({
    @required this.user,
    @required this.onSave,
    @required this.onCancel,
    @required this.selectedFlairID,
  }) : super();

  @override
  State<StatefulWidget> createState() => _ParticipantFlairSettingsState();
}

class _ParticipantFlairSettingsState extends State<ParticipantFlairSettings>
    with SingleTickerProviderStateMixin {
  String _selectedFlairID;
  AnimationController controller;
  Animation<Offset> offset;

  @override
  void initState() {
    super.initState();

    this._selectedFlairID = this.widget.selectedFlairID;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Refactor this into a SettingsCard widget
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          Intl.message('Change Flair'),
          style: TextThemes.goIncognitoHeader,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SpacingValues.extraSmall),
        Text(Intl.message('Be careful not to flex on people too hard.'),
            style: TextThemes.goIncognitoSubheader,
            textAlign: TextAlign.center),
        SizedBox(height: SpacingValues.mediumLarge),
        Container(height: 1.0, color: Color.fromRGBO(110, 111, 121, 0.6)),
        SizedBox(height: SpacingValues.mediumLarge),
        ListView(
          shrinkWrap: true,
          children: (this.widget.user.flairs?.map((flairObj) {
                    return ParticipantFlairSelectorOption(
                      flair: flairObj,
                      height: 40.0,
                      isSelected: flairObj.id == this._selectedFlairID,
                      onSelected: () {
                        this.setState(() {
                          this._selectedFlairID = flairObj.id;
                        });
                      },
                    );
                  })?.toList() ??
                  <ParticipantFlairSelectorOption>[]) +
              [
                ParticipantFlairSelectorOption(
                    flair: null,
                    height: 40.0,
                    isSelected: this._selectedFlairID == null,
                    onSelected: () {
                      this.setState(() {
                        this._selectedFlairID = null;
                      });
                    })
              ],
        ),
        SizedBox(height: SpacingValues.mediumLarge),
        Container(height: 1.0, color: Color.fromRGBO(110, 111, 121, 0.6)),
        // TODO: Life Achievement not here...?
        Padding(
          padding: EdgeInsets.symmetric(vertical: SpacingValues.medium),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              GoBack(height: 16.0, onPressed: this.widget.onCancel),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RaisedButton(
                    padding: EdgeInsets.symmetric(
                        horizontal: SpacingValues.xxLarge,
                        vertical: SpacingValues.medium),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                    color: Color.fromRGBO(247, 247, 255, 0.2),
                    child: Text(Intl.message('Update'),
                        style: TextThemes.goIncognitoButton),
                    onPressed: () {
                      this.widget.onSave(this._selectedFlairID);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
