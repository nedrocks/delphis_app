import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'home_page.dart';

class HomePageActionBar extends StatelessWidget {
  final HomePageTab currentTab;
  final Color backgroundColor;
  final VoidCallback onNewChatPressed;

  const HomePageActionBar({
    @required this.currentTab,
    @required this.backgroundColor,
    @required this.onNewChatPressed,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color.fromRGBO(34, 35, 40, 1.0), width: 1.5),
        borderRadius: BorderRadius.circular(24.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: SpacingValues.medium),
      color: this.backgroundColor,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: SpacingValues.xxLarge),
        height: 64.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Opacity(
              opacity: this.currentTab == HomePageTab.CHAT ? 1.0 : 0.4,
              child: SvgPicture.asset('assets/svg/chat-icon.svg'),
            ),
            Container(
              width: 145.0,
              height: 44.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                color: Color.fromRGBO(247, 247, 255, 1.0),
                child: Text(
                  Intl.message('New chat'),
                  style: TextThemes.homeScreenActionBarNewChat,
                ),
                onPressed: this.onNewChatPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
