import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/widgets/go_back/go_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'participant_settings.dart';

class ParticipantGradientSelector extends StatefulWidget {
  final GradientName selectedGradient;
  final GradientCallback onSave;
  final VoidCallback onCancel;

  const ParticipantGradientSelector({
    @required this.selectedGradient,
    @required this.onSave,
    @required this.onCancel,
  }) : super();

  @override
  State<StatefulWidget> createState() => _ParticipantGradientSelectorState();
}

class _ParticipantGradientSelectorState
    extends State<ParticipantGradientSelector> {
  GradientName _pickedGradient;

  @override
  void initState() {
    super.initState();

    // TODO: set this from the participant field.
    this._pickedGradient = this.widget.selectedGradient;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 140.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            scrollDirection: Axis.horizontal,
            children: anonymousGradients.map<Widget>((gradientName) {
              final isSelected = gradientName == this._pickedGradient;
              final gradient = ChathamColors.gradients[gradientName];
              var textStyle = TextThemes.gradientSelectorName;
              final str = gradientName.toString().split('.')[1].toLowerCase();
              Widget textWidget = Text(str, style: textStyle);
              if (isSelected) {
                textWidget = ShaderMask(
                  shaderCallback: (bounds) {
                    return gradient.createShader(Offset.zero & bounds.size);
                  },
                  child: Text(
                    str,
                    style: textStyle.copyWith(color: Colors.white),
                  ),
                );
              }
              var colorCircle = Container(
                width: 24.0,
                height: 24.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: gradient,
                ),
              );
              if (isSelected) {
                colorCircle = Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(1.5),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: gradient,
                          border: Border.all(
                            color: Color.fromRGBO(11, 12, 16, 1.0),
                          ),
                        ),
                      ),
                      SvgPicture.asset('assets/svg/check_mark.svg',
                          color: Colors.white, semanticsLabel: 'Selected')
                    ],
                  ),
                );
              }
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    this.setState(() {
                      this._pickedGradient = gradientName;
                    });
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        colorCircle,
                        SizedBox(height: SpacingValues.xxSmall),
                        textWidget,
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
                    child: Text(Intl.message('Save color'),
                        style: TextThemes.goIncognitoButton),
                    onPressed: () {
                      this.widget.onSave(this._pickedGradient);
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
