import 'package:delphis_app/bloc/participant/participant_bloc.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/discussion/overlay/participant_anonymity_setting_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'participant_flair_selector.dart';
import 'participant_gradient_selector.dart';

typedef void IntIdxCallback(int idx);
typedef void GradientCallback(GradientName gradientName);

enum _SettingsState {
  ANONYMITY_SELECT,
  FLAIR_SELECT,
  GRADIENT_SELECT,
}

class ParticipantAnonymitySettings extends StatefulWidget {
  final Participant meParticipant;
  final User me;
  final VoidCallback onClose;

  const ParticipantAnonymitySettings({
    @required this.meParticipant,
    @required this.me,
    @required this.onClose,
  }) : super();

  @override
  State<StatefulWidget> createState() => _ParticipantAnonymitySettingsState();
}

class _ParticipantAnonymitySettingsState
    extends State<ParticipantAnonymitySettings> {
  int _selectedIdx;
  _SettingsState _settingsState;

  @override
  void initState() {
    super.initState();
    // TODO: Pull this from participant via the User available flair.
    this._selectedIdx = 0;
    this._settingsState = _SettingsState.ANONYMITY_SELECT;
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (this._settingsState) {
      case _SettingsState.ANONYMITY_SELECT:
        child = Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              Intl.message('Go Incognito?'),
              style: TextThemes.goIncognitoHeader,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SpacingValues.extraSmall),
            Text(Intl.message('Pick how you want your avatar to display'),
                style: TextThemes.goIncognitoSubheader,
                textAlign: TextAlign.center),
            SizedBox(height: SpacingValues.mediumLarge),
            Container(height: 1.0, color: Color.fromRGBO(110, 111, 121, 0.6)),
            SizedBox(height: SpacingValues.mediumLarge),
            ListView(shrinkWrap: true, children: [
              ParticipantAnonymitySettingOption(
                  height: 40.0,
                  user: this.widget.me,
                  anonymousGradient: GradientName.AZALEA,
                  showAnonymous: false,
                  participant: this.widget.meParticipant,
                  isSelected: this._selectedIdx == 0,
                  onSelected: () {
                    setState(() {
                      this._selectedIdx = 0;
                    });
                  },
                  onEdit: () {
                    this.setState(() {
                      this._settingsState = _SettingsState.FLAIR_SELECT;
                    });
                  }),
              SizedBox(height: SpacingValues.mediumLarge),
              ParticipantAnonymitySettingOption(
                  height: 40.0,
                  user: this.widget.me,
                  anonymousGradient: GradientName.AZALEA,
                  showAnonymous: true,
                  participant: this.widget.meParticipant,
                  isSelected: this._selectedIdx == 1,
                  onSelected: () {
                    setState(() {
                      this._selectedIdx = 1;
                    });
                  },
                  onEdit: () {
                    this.setState(() {
                      this._settingsState = _SettingsState.GRADIENT_SELECT;
                    });
                  }),
            ]),
            SizedBox(height: SpacingValues.mediumLarge),
            Container(height: 1.0, color: Color.fromRGBO(110, 111, 121, 0.6)),
            Container(
                padding: EdgeInsets.symmetric(vertical: SpacingValues.medium),
                alignment: Alignment.center,
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(
                      horizontal: SpacingValues.xxLarge,
                      vertical: SpacingValues.medium),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  color: Color.fromRGBO(247, 247, 255, 0.2),
                  child: Text(Intl.message('Update'),
                      style: TextThemes.goIncognitoButton),
                  onPressed: () {
                    BlocProvider.of<ParticipantBloc>(context)
                        .add(ParticipantEventUpdateParticipant(
                      participantID: this.widget.meParticipant.id,
                      isAnonymous: this._selectedIdx == 1,
                    ));
                    this.widget.onClose();
                  },
                )),
          ],
        );
        break;
      case _SettingsState.FLAIR_SELECT:
        //child = SlideInTransition(
        child = ParticipantFlairSettings(
          user: this.widget.me,
          participant: this.widget.meParticipant,
          onSave: (int idx) {
            print('saved participant flair');
            this.setState(() {
              this._settingsState = _SettingsState.ANONYMITY_SELECT;
            });
          },
          onCancel: () {
            this.setState(() {
              this._settingsState = _SettingsState.ANONYMITY_SELECT;
            });
          },
        );
        // animationMillis: 500,
        // onAnimationComplete: () {
        //   print('animation complete');
        // });
        break;
      case _SettingsState.GRADIENT_SELECT:
        child = ParticipantGradientSelector(
          participant: this.widget.meParticipant,
          onSave: (GradientName name) {
            print('saved');
            this.setState(() {
              this._settingsState = _SettingsState.ANONYMITY_SELECT;
            });
          },
          onCancel: () {
            this.setState(() {
              this._settingsState = _SettingsState.ANONYMITY_SELECT;
            });
          },
        );
        break;
    }
    return Card(
        elevation: 50.0,
        color: Color.fromRGBO(22, 23, 28, 1.0),
        child: Container(
          padding: EdgeInsets.only(
              left: SpacingValues.extraLarge,
              right: SpacingValues.extraLarge,
              top: SpacingValues.mediumLarge),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 20.0,
                spreadRadius: 5.0,
                offset: Offset(0.0, -5.0),
              ),
            ],
            border:
                Border.all(color: Color.fromRGBO(34, 35, 40, 1.0), width: 1.5),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(36.0),
                topRight: Radius.circular(36.0)),
          ),
          child: child,
        ));
  }
}
