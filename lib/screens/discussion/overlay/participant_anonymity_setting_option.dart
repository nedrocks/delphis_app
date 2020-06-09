import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/widgets/profile_image/profile_image_with_gradient.dart';
import 'package:delphis_app/widgets/settings/setting_option.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ParticipantAnonymitySettingOption extends StatelessWidget {
  final Participant participant;
  final User user;
  final bool showAnonymous;
  final GradientName anonymousGradient;
  final bool isSelected;
  final VoidCallback onSelected;
  final VoidCallback onEdit;
  final double height;
  final bool showEditButton;

  const ParticipantAnonymitySettingOption({
    @required this.participant,
    @required this.user,
    @required this.showAnonymous,
    @required this.anonymousGradient,
    @required this.isSelected,
    @required this.onSelected,
    @required this.onEdit,
    @required this.height,
    this.showEditButton = true,
  }) : super();

  @override
  Widget build(BuildContext context) {
    Widget editContent = Text(
      Intl.message('Edit'),
      style: TextThemes.goIncognitoOptionAction,
      textAlign: TextAlign.end,
    );

    if (!this.showEditButton) {
      editContent = Container(width: 0, height: 0);
    }

    return SettingOption(
      isSelected: this.isSelected,
      onSelected: this.onSelected,
      onEdit: this.onEdit,
      height: this.height,
      leftSideContent: Row(children: [
        SizedBox(width: SpacingValues.small),
        ProfileImageWithGradient(
          participant: this.participant,
          width: this.height,
          height: this.height,
          anonymousOverride: this.showAnonymous,
          me: this.user,
          gradientNameOverride: this.anonymousGradient,
        ),
        SizedBox(width: SpacingValues.small),
        Text(
            this.showAnonymous
                ? '${gradientColorFromGradientName(this.anonymousGradient).toLowerCase()} #${this.participant.participantID}'
                : this.user.profile.displayName,
            style: TextThemes.goIncognitoOptionName),
        SizedBox(width: SpacingValues.small),
        this._renderFlair(),
      ]),
      editContent: editContent,
    );
  }

  Widget _renderFlair() {
    return Container();
  }
}
