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

  const ParticipantAnonymitySettingOption({
    @required this.participant,
    @required this.user,
    @required this.showAnonymous,
    @required this.anonymousGradient,
    @required this.isSelected,
    @required this.onSelected,
    @required this.onEdit,
    @required this.height,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return SettingOption(
      isSelected: this.isSelected,
      onSelected: this.onSelected,
      onEdit: this.onEdit,
      height: this.height,
      leftSideContent: Row(children: [
        SizedBox(width: SpacingValues.small),
        ProfileImageWithGradient(
          participant: this.participant,
          isAnonymous: this.showAnonymous,
          width: this.height,
          height: this.height,
          me: this.user,
        ),
        SizedBox(width: SpacingValues.small),
        Text(
            this.showAnonymous ? 'Cinnabar #22' : this.user.profile.displayName,
            style: TextThemes.goIncognitoOptionName),
        SizedBox(width: SpacingValues.small),
        this._renderFlair(),
      ]),
      editContent: Text(
        this.showAnonymous ? Intl.message('Edit') : Intl.message('Add flair'),
        style: TextThemes.goIncognitoOptionAction,
        textAlign: TextAlign.end,
      ),
    );
  }

  Widget _renderFlair() {
    return Container();
  }
}
