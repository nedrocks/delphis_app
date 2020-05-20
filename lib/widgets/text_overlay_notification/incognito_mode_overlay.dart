import 'package:delphis_app/design/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './text_overlay_notification.dart';

class IncognitoModeTextOverlay extends StatelessWidget {
  final bool hasGoneIncognito;

  const IncognitoModeTextOverlay({
    @required this.hasGoneIncognito,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return TextOverlayNotification(
        text: Intl.message(
            'Incognito mode activated. Remember, don\'t be a scallywag.'),
        borderGradient: LinearGradient(colors: [
          Color.fromRGBO(42, 190, 94, 1.0),
          Color.fromRGBO(60, 116, 156, 1.0),
        ], stops: [
          0.0,
          0.4,
        ]),
        icon: null);
  }
}
