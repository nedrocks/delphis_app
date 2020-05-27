import 'package:flutter/material.dart';

final kThemeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  accentColor: Colors.white,
  fontFamily: 'NeueHansKendrick',
  textTheme: TextTheme(
    headline1: TextThemes.discussionTitle,
    headline2: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w700,
        color: Color.fromRGBO(255, 255, 255, 0.8),
        letterSpacing: -0.22,
        height: 1.0),
    // It's strange to have a headline3 smaller than the body text. Not sure if there's a better way to lay this out?
    headline3: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: Color.fromRGBO(255, 255, 255, 0.48),
        letterSpacing: -0.19,
        height: 1.0),
    bodyText1: TextThemes.discussionPostText,
    bodyText2: TextThemes.discussionPostInput,
  ),
);

class TextThemes {
  static final discussionTitle = TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      color: Color.fromRGBO(255, 255, 255, 0.92),
      letterSpacing: 0.14,
      height: 1.0);

  static final discussionPostText = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(255, 255, 255, 0.92),
    letterSpacing: -0.39,
    height: 1.2,
  );
  static final discussionPostInput = TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: Color.fromRGBO(255, 255, 255, 1.0),
      letterSpacing: 0.1,
      textBaseline: TextBaseline.alphabetic,
      decoration: TextDecoration.none,
      height: 1.0);

  static final discussionPostAuthorNonAnon = TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Color.fromRGBO(255, 255, 255, 0.92),
      letterSpacing: -0.22,
      height: 1.0);
  static final discussionPostAuthorAnon =
      TextThemes.discussionPostAuthorNonAnon.copyWith(
    color: Color.fromRGBO(218, 219, 236, 0.8),
  );

  static final onboardHeading = TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w800,
      color: Color.fromRGBO(255, 255, 255, 1.0),
      letterSpacing: -0.22,
      height: 1.25);
  static final onboardBody = TextStyle(
      fontSize: 19.0,
      fontWeight: FontWeight.w400,
      color: Color.fromRGBO(255, 255, 255, 1.0),
      letterSpacing: 0.11,
      height: 1.26);
  static final signInWithTwitter = TextStyle(
      fontSize: 19.0,
      fontWeight: FontWeight.w600,
      color: Color.fromRGBO(11, 12, 16, 1.0),
      letterSpacing: -0.33,
      height: 1.0);
  static final signInAngryNote = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(247, 247, 255, 0.88),
    letterSpacing: 0.06,
    height: 2.182,
    decoration: TextDecoration.underline,
  );

  static final discussionPostAuthorAnonDescriptor = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    color: Color.fromRGBO(218, 219, 236, 0.48),
    letterSpacing: -0.19,
    height: 1.667,
  );
  static final discussionPostAuthorNonAnonDescriptor =
      TextThemes.discussionPostAuthorAnonDescriptor.copyWith(
    color: Color.fromRGBO(255, 255, 255, 0.6),
  );

  static final discussionAdditionalParticipants = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w700,
    color: Color.fromRGBO(247, 247, 255, 1.0),
    letterSpacing: -1.08,
    height: 1.0,
  );
  static final discussionAdditionalParticipantsPlusSign =
      TextThemes.discussionAdditionalParticipants.copyWith(
    fontSize: 9.0,
    letterSpacing: -0.75,
  );

  static final goIncognitoHeader = TextStyle(
    fontSize: 19.0,
    fontWeight: FontWeight.w700,
    color: Color.fromRGBO(247, 247, 255, 1.0),
    letterSpacing: -0.25,
    height: 1.473,
  );
  static final goIncognitoSubheader = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(227, 227, 236, 1.0),
    letterSpacing: 0.09,
    height: 1.267,
  );
  static final goIncognitoOptionName = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: -0.22,
    height: 1.429,
  );
  static final goIncognitoOptionAction = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(200, 200, 207, 1.0),
    letterSpacing: -0.17,
    height: 1.3846,
  );
  static final goIncognitoButton = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: -0.22,
    height: 1.412,
  );

  static final backButton = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(200, 200, 207, 1.0),
    letterSpacing: -0.19,
    height: 1.4667,
  );

  static final gradientSelectorName = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: Color.fromRGBO(255, 255, 255, 0.92),
    letterSpacing: -0.19,
    height: 1.6667,
  );

  static final textOverlayNotification = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    color: Color.fromRGBO(255, 255, 255, 1.0),
    letterSpacing: -0.22,
    height: 1.3,
    inherit: false,
  );

  static final moderatorNameChatTab = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    color: Color.fromRGBO(255, 255, 255, 0.92),
    letterSpacing: -0.25,
    height: 1.3636,
  );
  static final inviteTextChatTab = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(255, 255, 255, 0.64),
    letterSpacing: -0.23,
    height: 1.5,
  );
  static final discussionTitleChatTab = TextStyle(
    fontSize: 19.0,
    fontWeight: FontWeight.w600,
    color: Color.fromRGBO(247, 247, 255, 0.92),
    letterSpacing: -0.42,
    height: 1.3684,
  );
  static final joinButtonTextChatTab = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    color: Color.fromRGBO(23, 23, 28, 1.0),
    letterSpacing: -0.22,
  );
  static final deleteButtonTextChatTab = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w600,
    color: Color.fromRGBO(255, 255, 255, 1.0),
    letterSpacing: -0.13,
  );

  static final notificationBadgeText = TextStyle(
    fontSize: 9.0,
    fontWeight: FontWeight.w800,
    color: Color.fromRGBO(247, 247, 255, 1.0),
    letterSpacing: -1.6,
  );
}
