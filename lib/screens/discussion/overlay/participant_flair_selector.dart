import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/discussion/overlay/participant_anonymity_settings.dart';
import 'package:delphis_app/screens/discussion/overlay/participant_flair_selector_option.dart';
import 'package:delphis_app/widgets/go_back/go_back.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ParticipantFlairSettings extends StatefulWidget {
  final User user;
  final Participant participant;
  final IntIdxCallback onSave;
  final VoidCallback onCancel;

  const ParticipantFlairSettings({
    @required this.user,
    @required this.participant,
    @required this.onSave,
    @required this.onCancel,
  }) : super();

  @override
  State<StatefulWidget> createState() => _ParticipantFlairSettingsState();
}

class _ParticipantFlairSettingsState extends State<ParticipantFlairSettings>
    with SingleTickerProviderStateMixin {
  int _selectedIdx;
  AnimationController controller;
  Animation<Offset> offset;

  @override
  void initState() {
    super.initState();

    // TODO: pull this from user / participant
    this._selectedIdx = -1;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Refactor this into a SettingsCard widget
    return Column(
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
        Expanded(
          flex: 3,
          child: ListView(
            children: [
              ParticipantFlairSelectorOption(
                  height: 40.0,
                  isSelected: this._selectedIdx == 0,
                  onSelected: () {
                    setState(() {
                      this._selectedIdx = 0;
                    });
                  }),
              ParticipantFlairSelectorOption(
                  height: 40.0,
                  isSelected: this._selectedIdx == 1,
                  onSelected: () {
                    setState(() {
                      this._selectedIdx = 1;
                    });
                  }),
              ParticipantFlairSelectorOption(
                  height: 40.0,
                  isSelected: this._selectedIdx == 2,
                  onSelected: () {
                    setState(() {
                      this._selectedIdx = 2;
                    });
                  }),
              ParticipantFlairSelectorOption(
                  height: 40.0,
                  isSelected: this._selectedIdx == 3,
                  onSelected: () {
                    setState(() {
                      this._selectedIdx = 3;
                    });
                  }),
            ],
          ),
        ),
        SizedBox(height: SpacingValues.mediumLarge),
        Container(height: 1.0, color: Color.fromRGBO(110, 111, 121, 0.6)),
        // TODO: Life Achievement not here...?
        Expanded(
          flex: 2,
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
                      this.widget.onSave(this._selectedIdx);
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
