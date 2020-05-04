import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/widgets/go_back/go_back.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'participant_anonymity_settings.dart';

class ParticipantGradientSelector extends StatefulWidget {
  final Participant participant;
  final GradientCallback onSave;
  final VoidCallback onCancel;

  const ParticipantGradientSelector({
    @required this.participant,
    @required this.onSave,
    @required this.onCancel,
  }) : super();

  @override
  State<StatefulWidget> createState() => _ParticipantGradientSelectorState();
}

class _ParticipantGradientSelectorState
    extends State<ParticipantGradientSelector> {
  GradientName _selectedGradient;

  @override
  void initState() {
    super.initState();

    // TODO: set this from the participant field.
    this._selectedGradient = GradientName.AZALEA;
  }

  @override
  Widget build(BuildContext context) {
    print('making the gradient selector');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          Intl.message('Change Color'),
          style: TextThemes.goIncognitoHeader,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SpacingValues.extraSmall),
        Text(Intl.message('Pick something snazzy that speaks to you'),
            style: TextThemes.goIncognitoSubheader,
            textAlign: TextAlign.center),
        SizedBox(height: SpacingValues.mediumLarge),
        Container(height: 1.0, color: Color.fromRGBO(110, 111, 121, 0.6)),
        SizedBox(height: SpacingValues.mediumLarge),
        Expanded(
          flex: 3,
          child: GridView.count(
            crossAxisCount: 3,
            scrollDirection: Axis.horizontal,
            children: anonymousGradients.map<Widget>((gradientName) {
              final isSelected = gradientName == this._selectedGradient;
              final gradient = ChathamColors.gradients[gradientName];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    this.setState(() {
                      this._selectedGradient = gradientName;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 1.0)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24.0, // Maybe?
                          height: 24.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: gradient,
                          ),
                        ),
                        SizedBox(height: SpacingValues.xxSmall),
                        Text(
                            gradientName.toString().split('.')[1].toLowerCase(),
                            style: TextThemes.gradientSelectorName),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: SpacingValues.mediumLarge),
        Container(height: 1.0, color: Color.fromRGBO(110, 111, 121, 0.6)),
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
                    child: Text(Intl.message('Save color'),
                        style: TextThemes.goIncognitoButton),
                    onPressed: () {
                      this.widget.onSave(this._selectedGradient);
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
