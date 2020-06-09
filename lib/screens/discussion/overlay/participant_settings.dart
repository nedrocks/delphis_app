import 'package:delphis_app/bloc/participant/participant_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/discussion/overlay/participant_anonymity_setting_option.dart';
import 'package:delphis_app/util/callbacks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'participant_flair_selector.dart';
import 'participant_gradient_selector.dart';

typedef void IDCallback(String id);
typedef void GradientCallback(GradientName gradientName);

enum _SettingsState {
  ANONYMITY_SELECT,
  FLAIR_SELECT,
  GRADIENT_SELECT,
}

enum SettingsFlow {
  PARTICIPANT_SETTINGS_IN_CHAT,
  JOIN_CHAT,
}

class ParticipantSettings extends StatefulWidget {
  final Discussion discussion;
  final Participant meParticipant;
  final User me;
  final SettingsFlow settingsFlow;
  final SuccessCallback onClose;
  final ParticipantBloc participantBloc;

  const ParticipantSettings({
    @required this.discussion,
    @required this.meParticipant,
    @required this.me,
    @required this.onClose,
    this.settingsFlow = SettingsFlow.PARTICIPANT_SETTINGS_IN_CHAT,
    this.participantBloc,
  }) : super();

  @override
  State<StatefulWidget> createState() => _ParticipantSettingsState();
}

class _ParticipantSettingsState extends State<ParticipantSettings> {
  GradientName _selectedGradient;
  String _selectedFlairID;
  int _selectedIdx;
  _SettingsState _settingsState;

  @override
  void initState() {
    super.initState();
    this._selectedIdx = 0;
    this._settingsState = _SettingsState.ANONYMITY_SELECT;
    this._selectedGradient =
        gradientNameFromString(this.widget.meParticipant?.gradientColor);
    this._selectedFlairID = this.widget.meParticipant?.flair?.id;
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (this._settingsState) {
      case _SettingsState.ANONYMITY_SELECT:
        Color actionButtonColor = Color.fromRGBO(247, 247, 255, 0.2);
        Text actionButtonText = Text(
          Intl.message('Update'),
          style: TextThemes.goIncognitoButton,
        );
        if (this.widget.settingsFlow == SettingsFlow.JOIN_CHAT) {
          actionButtonColor = Color.fromRGBO(247, 247, 255, 1.0);
          actionButtonText = Text(
            Intl.message('Join'),
            style: TextThemes.joinButtonTextChatTab,
          );
        }

        final actionButton = RaisedButton(
          padding: EdgeInsets.symmetric(
              horizontal: SpacingValues.xxLarge,
              vertical: SpacingValues.medium),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          color: actionButtonColor,
          child: actionButtonText,
          onPressed: () {
            if (this.widget.settingsFlow == SettingsFlow.JOIN_CHAT) {
              this.joinDiscussion();
            } else {
              this.updateExistingParticipant();
            }
          },
        );
        child = Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              this.widget.settingsFlow ==
                      SettingsFlow.PARTICIPANT_SETTINGS_IN_CHAT
                  ? Intl.message('Go Incognito?')
                  : Intl.message('How would you like to join?'),
              style: TextThemes.goIncognitoHeader,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SpacingValues.extraSmall),
            Text(Intl.message('Pick how you want your avatar to display.'),
                style: TextThemes.goIncognitoSubheader,
                textAlign: TextAlign.center),
            SizedBox(height: SpacingValues.mediumLarge),
            Container(height: 1.0, color: Color.fromRGBO(110, 111, 121, 0.6)),
            SizedBox(height: SpacingValues.mediumLarge),
            ListView(shrinkWrap: true, children: [
              ParticipantAnonymitySettingOption(
                height: 40.0,
                user: this.widget.me,
                anonymousGradient: this._selectedGradient,
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
                },
                showEditButton: this.widget.me.flairs != null &&
                    this.widget.me.flairs.length > 0,
              ),
              SizedBox(height: SpacingValues.mediumLarge),
              ParticipantAnonymitySettingOption(
                  height: 40.0,
                  user: this.widget.me,
                  anonymousGradient: this._selectedGradient,
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
            Padding(
                padding: EdgeInsets.symmetric(vertical: SpacingValues.medium),
                child: Stack(alignment: Alignment.centerLeft, children: [
                  this.widget.settingsFlow ==
                          SettingsFlow.PARTICIPANT_SETTINGS_IN_CHAT
                      ? GestureDetector(
                          onTap: () {
                            this.widget.onClose(false);
                          },
                          child: Text(
                            Intl.message('Cancel'),
                            style: TextThemes.signInAngryNote,
                          ))
                      : Container(width: 0, height: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [actionButton],
                  ),
                ])),
          ],
        );
        break;
      case _SettingsState.FLAIR_SELECT:
        //child = SlideInTransition(
        child = ParticipantFlairSettings(
          user: this.widget.me,
          selectedFlairID: this.widget.meParticipant.flair?.id,
          onSave: (String id) {
            this.setState(() {
              this._selectedFlairID = id;
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
      case _SettingsState.GRADIENT_SELECT:
        child = ParticipantGradientSelector(
          selectedGradient: this._selectedGradient,
          onSave: (GradientName name) {
            this.setState(() {
              this._selectedGradient = name;
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

  void updateExistingParticipant() {
    (this.widget.participantBloc ?? BlocProvider.of<ParticipantBloc>(context))
        .add(ParticipantEventUpdateParticipant(
      participantID: this.widget.meParticipant.id,
      isAnonymous: this._selectedIdx == 1,
      gradientName: this._selectedGradient,
      flair: this.widget.me.flairs.firstWhere(
          (flair) => flair.id == this._selectedFlairID,
          orElse: () => null),
      isUnsetFlairID: this._selectedFlairID == null,
    ));
    this.widget.onClose(true);
  }

  void joinDiscussion() {
    (this.widget.participantBloc ?? BlocProvider.of<ParticipantBloc>(context))
        .add(ParticipantEventAddParticipant(
      discussionID: this.widget.discussion.id,
      userID: this.widget.me.id,
      gradientName: this._selectedGradient,
      flairID: this._selectedFlairID,
      hasJoined: true,
      isAnonymous: this._selectedIdx == 1,
    ));
    this.widget.onClose(true);
  }
}
