import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/home_page/home_page_topbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BasePageWidget extends StatelessWidget {
  final Widget contents;
  final String title;
  final String backButtonText;
  final String nextButtonText;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const BasePageWidget({
    @required this.contents,
    @required this.title,
    @required this.backButtonText,
    @required this.nextButtonText,
    @required this.onNext,
    @required this.onBack,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(bottom: SpacingValues.large),
        child: Column(
          children: [
            Container(
              color: ChathamColors.topBarBackgroundColor,
            ),
            HomePageTopBar(
              height: 80.0,
              title: Intl.message(title),
              backgroundColor: ChathamColors.topBarBackgroundColor,
            ),
            this.contents,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RaisedButton(
                  padding: EdgeInsets.symmetric(
                    horizontal: SpacingValues.large,
                    vertical: SpacingValues.medium,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  color: Color.fromRGBO(247, 247, 255, 0.2),
                  child: Text(this.backButtonText),
                  onPressed: this.onBack,
                ),
                RaisedButton(
                  padding: EdgeInsets.symmetric(
                    horizontal: SpacingValues.xxLarge,
                    vertical: SpacingValues.medium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  color: Color.fromRGBO(247, 247, 255, 1.0),
                  child: Text(
                    Intl.message(this.nextButtonText),
                    style: TextThemes.joinButtonTextChatTab,
                  ),
                  onPressed: this.onNext,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
