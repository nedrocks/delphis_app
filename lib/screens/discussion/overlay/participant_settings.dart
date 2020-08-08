import 'package:delphis_app/bloc/notification/notification_bloc.dart';
import 'package:delphis_app/bloc/participant/participant_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/discussion/overlay/participant_anonymity_setting_option.dart';
import 'package:delphis_app/util/callbacks.dart';
import 'package:delphis_app/util/display_names.dart';
import 'package:delphis_app/widgets/overlay/overlay_top_message.dart';
import 'package:delphis_app/widgets/profile_image/profile_image.dart';
import 'package:delphis_app/widgets/text_overlay_notification/incognito_mode_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  bool _didChange;
  bool _showLoading;

  @override
  void initState() {
    super.initState();
    this._didChange = false;
    this._selectedIdx = -1;
    this._settingsState = _SettingsState.ANONYMITY_SELECT;
    this._selectedGradient =
        gradientNameFromString(this.widget.meParticipant?.gradientColor);
    this._selectedFlairID = this.widget.meParticipant?.flair?.id;
    this._showLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (this._settingsState) {
      case _SettingsState.ANONYMITY_SELECT:
        bool actionButtonEnabled = _didChange;
        Color actionButtonColor = _didChange
            ? Color.fromRGBO(247, 247, 255, 0.2)
            : Color.fromRGBO(247, 247, 255, 1.0);
        Widget actionButtonText = Text(
          Intl.message('Update'),
          style: TextThemes.goIncognitoButton,
        );
        if (this._showLoading) {
          actionButtonText = Center(
            child: CircularProgressIndicator(),
          );
        } else if (this.widget.settingsFlow == SettingsFlow.JOIN_CHAT) {
          actionButtonEnabled = true;
          actionButtonColor = Color.fromRGBO(247, 247, 255, 1.0);
          actionButtonText = Text(
            Intl.message('Join'),
            style: TextThemes.joinButtonTextChatTab,
          );
        }

        Widget actionButton = RaisedButton(
          padding: EdgeInsets.symmetric(
              horizontal: SpacingValues.xxLarge,
              vertical: SpacingValues.medium),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          color: actionButtonColor,
          child: actionButtonText,
          onPressed: !actionButtonEnabled
              ? null
              : () {
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
            buildTitle(),
            SizedBox(height: SpacingValues.extraSmall),
            buildSubTitle(),
            SizedBox(height: SpacingValues.mediumLarge),
            Container(height: 1.0, color: Color.fromRGBO(110, 111, 121, 0.6)),
            ListView(
                padding: EdgeInsets.symmetric(vertical: SpacingValues.small),
                shrinkWrap: true,
                children: buildSettingsList()),
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
                            style: TextThemes.cancelText,
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
              this._didChange = true;
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
              this._didChange = true;
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
    if (this._showLoading) {
      child = Opacity(
        opacity: 0.4,
        child: child,
      );
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
                Border.all(color: Color.fromRGBO(22, 25, 28, 1.0), width: 1.5),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(36.0),
                topRight: Radius.circular(36.0)),
          ),
          child: child,
        ));
  }

  void updateExistingParticipant() {
    var didUpdate =
        (this._selectedIdx == 1) != this.widget.meParticipant.isAnonymous;
    final notifBloc = BlocProvider.of<NotificationBloc>(context);
    var onSuccess = !didUpdate
        ? () {}
        : () {
            notifBloc.add(
              NewNotificationEvent(
                notification: OverlayTopMessage(
                  showForMs: 2000,
                  child: IncognitoModeTextOverlay(
                    hasGoneIncognito: _selectedIdx == 1,
                  ),
                  onDismiss: () {
                    notifBloc.add(DismissNotification());
                  },
                ),
              ),
            );
          };
    var onError = (error) {
      notifBloc.add(
        NewNotificationEvent(
          notification: OverlayTopMessage(
            showForMs: 3000,
            child: IncognitoModeTextOverlay(
              hasGoneIncognito: _selectedIdx == 1,
              textOverride: error.toString(),
            ),
            onDismiss: () {
              notifBloc.add(DismissNotification());
            },
          ),
        ),
      );
    };

    (this.widget.participantBloc ?? BlocProvider.of<ParticipantBloc>(context))
        .add(ParticipantEventUpdateParticipant(
            participantID: this.widget.meParticipant.id,
            isAnonymous: this._selectedIdx == 1,
            gradientName: this._selectedGradient,
            flair: this.widget.me.flairs.firstWhere(
                (flair) => flair.id == this._selectedFlairID,
                orElse: () => null),
            isUnsetFlairID: this._selectedFlairID == null,
            onSuccess: onSuccess,
            onError: onError));
    this.widget.onClose(didUpdate);
  }

  void joinDiscussion() async {
    final participantBloc = this.widget.participantBloc ??
        BlocProvider.of<ParticipantBloc>(context);

    participantBloc.add(ParticipantEventAddParticipant(
      discussionID: this.widget.discussion.id,
      userID: this.widget.me.id,
      gradientName: this._selectedGradient,
      flairID: this._selectedFlairID,
      hasJoined: true,
      isAnonymous: this._selectedIdx == 1,
    ));
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        this._showLoading = true;
      });
    });
    while (true) {
      await Future.delayed(Duration(milliseconds: 300));
      final state = participantBloc.state;
      if (state is ParticipantLoaded && !state.isUpdating) {
        break;
      }
    }
    this.widget.onClose(true);
  }

  List<Widget> buildSettingsList() {
    List<Widget> list = [];
    if ((this.widget.meParticipant != null &&
            this.widget.meParticipant.isAnonymous) ||
        this.widget.settingsFlow == SettingsFlow.JOIN_CHAT ||
        this.widget.discussion.isMeDiscussionModerator()) {
      list.add(ParticipantAnonymitySettingOption(
        height: 40.0,
        user: this.widget.me,
        anonymousGradient: this._selectedGradient,
        showAnonymous: false,
        participant: this.widget.meParticipant,
        discussion: this.widget.discussion,
        isSelected: this._selectedIdx == 0,
        onSelected: () {
          setState(() {
            this._selectedIdx = 0;
            this._didChange = true;
          });
        },
        onEdit: () {
          this.setState(() {
            this._settingsState = _SettingsState.FLAIR_SELECT;
          });
        },
        showEditButton:
            this.widget.me.flairs != null && this.widget.me.flairs.length > 0,
      ));
    }

    if ((!this.widget.meParticipant.isAnonymous ||
            this.widget.settingsFlow == SettingsFlow.JOIN_CHAT) &&
        !this.widget.discussion.isMeDiscussionModerator()) {
      var onEdit = () {
        this.setState(() {
          this._settingsState = _SettingsState.FLAIR_SELECT;
        });
      };
      if (this.widget.settingsFlow == SettingsFlow.JOIN_CHAT) {
        onEdit = () {
          this.setState(() {
            this._settingsState = _SettingsState.GRADIENT_SELECT;
          });
        };
      }
      list.add(ParticipantAnonymitySettingOption(
        height: 40.0,
        user: this.widget.me,
        anonymousGradient: this._selectedGradient,
        showAnonymous: true,
        participant: this.widget.meParticipant,
        discussion: this.widget.discussion,
        isSelected: this._selectedIdx == 1,
        onSelected: () {
          setState(() {
            this._selectedIdx = 1;
            this._didChange = true;
          });
        },
        onEdit: onEdit,
        showEditButton: this.widget.settingsFlow == SettingsFlow.JOIN_CHAT ||
            (this.widget.me.flairs != null && this.widget.me.flairs.length > 0),
      ));
    }

    return list;
  }

  Widget buildTitle() {
    if (this.widget.discussion.isMeDiscussionModerator()) {
      return Text(
        this.widget.settingsFlow == SettingsFlow.PARTICIPANT_SETTINGS_IN_CHAT
            ? Intl.message('Settings')
            : Intl.message('How would you like to join?'),
        style: TextThemes.goIncognitoHeader,
        textAlign: TextAlign.center,
      );
    }
    return Text(
      this.widget.settingsFlow == SettingsFlow.PARTICIPANT_SETTINGS_IN_CHAT
          ? (this.widget.meParticipant.isAnonymous
              ? Intl.message("Go Public?")
              : Intl.message('Go Incognito?'))
          : Intl.message('How would you like to join?'),
      style: TextThemes.goIncognitoHeader,
      textAlign: TextAlign.center,
    );
  }

  Widget buildSubTitle() {
    var displayName = DisplayNames.formatParticipant(
        this.widget.discussion.moderator, this.widget.meParticipant);
    var profileImage = ProfileImage(
        height: TextThemes.goIncognitoSubheader.fontSize * 1.3,
        width: TextThemes.goIncognitoSubheader.fontSize * 1.3,
        profileImageURL: this.widget.meParticipant.userProfile?.profileImageURL,
        isAnonymous: this.widget.meParticipant.isAnonymous);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextThemes.goIncognitoSubheader,
        children: [
          TextSpan(text: Intl.message('You are currently posting as:\n')),
          WidgetSpan(child: profileImage),
          TextSpan(
              text: ' $displayName',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          TextSpan(
              text:
                  Intl.message('.\nPick how you want your avatar to display.')),
        ],
      ),
    );
  }
}
