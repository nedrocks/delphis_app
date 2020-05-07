import 'package:delphis_app/data/repository/flair.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/widgets/anon_profile_image/anon_profile_image.dart';
import 'package:delphis_app/widgets/settings/setting_option.dart';
import 'package:delphis_app/widgets/verified_checkmark/verified_checkmark.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ParticipantFlairSelectorOption extends StatelessWidget {
  final Flair flair;
  final bool isSelected;
  final VoidCallback onSelected;
  final double height;

  const ParticipantFlairSelectorOption({
    @required this.flair,
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
        this.flair?.imageURL == null
            ? AnonProfileImage(
                height: this.height,
                width: this.height,
                border: Border.all(color: Colors.white, width: 1.0))
            : Container(
                height: this.height,
                width: this.height,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.transparent,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(this.flair.imageURL),
                  ),
                )),
        SizedBox(width: SpacingValues.small),
        Text(
            this.flair == null
                ? Intl.message('Roll Incognito (No Flair)')
                : this.flair.displayName,
            style: TextThemes.goIncognitoOptionName),
        SizedBox(width: SpacingValues.medium),
        VerifiedCheckmark(
            height: TextThemes.goIncognitoOptionName.height *
                TextThemes.goIncognitoOptionName.fontSize),
      ]),
    );
  }
}
