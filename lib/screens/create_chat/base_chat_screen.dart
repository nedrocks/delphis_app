import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/home_page/home_page_topbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BaseCreateChatScreen extends StatelessWidget {
  final Widget contents;
  final String title;

  final VoidCallback onContinue;
  final VoidCallback onCancel;

  const BaseCreateChatScreen({
    @required this.contents,
    @required this.title,
    @required this.onContinue,
    @required this.onCancel,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final windowPadding = MediaQuery.of(context).padding;
    return Padding(
      padding: EdgeInsets.only(bottom: windowPadding.bottom),
      child: Column(
        children: [
          Container(
            height: windowPadding.top,
            color: ChathamColors.topBarBackgroundColor,
          ),
          HomePageTopBar(
            height: 80.0,
            title: Intl.message(title),
            backgroundColor: ChathamColors.topBarBackgroundColor,
          ),
          Expanded(
            child: this.contents,
          ),
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
                // TODO: This should probably be `Cancel` if it's the first screen.
                child: Text(Intl.message('Back')),
                onPressed: this.onCancel,
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
                // TODO: This should probably be `Save` if it's the last screen.
                child: Text(
                  Intl.message('Next'),
                  style: TextThemes.joinButtonTextChatTab,
                ),
                onPressed: this.onContinue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
