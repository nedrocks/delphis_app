import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/screens/discussion/header_options_button.dart';
import 'package:delphis_app/screens/home_page/home_page_action_bar_item.dart';
import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'home_page.dart';

class HomePageActionBar extends StatelessWidget {
  final HomePageTab currentTab;
  final Color backgroundColor;
  final VoidCallback onNewChatPressed;
  final HomePageChatTabCallback onTabPressed;
  final HeaderOptionsCallback onOptionSelected;

  const HomePageActionBar({
    @required this.currentTab,
    @required this.backgroundColor,
    @required this.onNewChatPressed,
    @required this.onTabPressed,
    @required this.onOptionSelected,
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
        padding: EdgeInsets.symmetric(
          horizontal: SpacingValues.mediumLarge,
        ),
        height: 64.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  HomePageActionBarItem(
                    icon: SvgPicture.asset(
                      'assets/svg/chat-icon.svg',
                      width: 26,
                      height: 26,
                    ),
                    title: "Active",
                    onPressed: () {
                      if (this.currentTab != HomePageTab.ACTIVE) {
                        this.onTabPressed(HomePageTab.ACTIVE);
                      }
                    },
                    active: this.currentTab == HomePageTab.ACTIVE,
                  ),
                  HomePageActionBarItem(
                    icon: Icon(
                      Icons.archive,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: "Archived",
                    onPressed: () {
                      if (this.currentTab != HomePageTab.ARCHIVED) {
                        this.onTabPressed(HomePageTab.ARCHIVED);
                      }
                    },
                    active: this.currentTab == HomePageTab.ARCHIVED,
                  ),
                  HomePageActionBarItem(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: "Deleted",
                    onPressed: () {
                      if (this.currentTab != HomePageTab.TRASHED) {
                        this.onTabPressed(HomePageTab.TRASHED);
                      }
                    },
                    active: this.currentTab == HomePageTab.TRASHED,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      color: Color.fromRGBO(247, 247, 255, 1.0),
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                        semanticLabel: "Add a discussion",
                      ),
                      onPressed: this.onNewChatPressed,
                    ),
                  ),
                  HeaderOptionsButton(
                    diameter: 38.0,
                    isVertical: true,
                    onPressed: this.onOptionSelected,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
