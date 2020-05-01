import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/widgets/anon_profile_image/anon_profile_image.dart';
import 'package:delphis_app/widgets/settings/setting_option.dart';
import 'package:delphis_app/widgets/verified_checkmark/verified_checkmark.dart';
import 'package:flutter/material.dart';

class ParticipantFlairSelectorOption extends StatelessWidget {
  // Flair flair;
  final bool isSelected;
  final VoidCallback onSelected;
  final double height;

  const ParticipantFlairSelectorOption({
    // @required this.flair,
    @required this.isSelected,
    @required this.onSelected,
    @required this.height,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return SettingOption(
      isSelected: this.isSelected,
      onSelected: this.onSelected,
      height: this.height,
      leftSideContent: Row(children: [
        SizedBox(width: SpacingValues.small),
        AnonProfileImage(height: this.height, width: this.height),
        SizedBox(width: SpacingValues.small),
        Text('Some flair description', style: TextThemes.goIncognitoOptionName),
        SizedBox(width: SpacingValues.medium),
        VerifiedCheckmark(
            height: TextThemes.goIncognitoOptionName.height *
                TextThemes.goIncognitoOptionName.fontSize),
      ]),
    );
  }
}
