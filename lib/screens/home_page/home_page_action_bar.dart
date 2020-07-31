import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/screens/discussion/header_options_button.dart';
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
        padding: EdgeInsets.symmetric(horizontal: SpacingValues.xxLarge),
        height: 64.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Pressable(
                  onPressed: () {
                    if (this.currentTab != HomePageTab.ACTIVE) {
                      this.onTabPressed(HomePageTab.ACTIVE);
                    }
                  },
                  width: 44.0,
                  height: 44.0,
                  showInkwell: false,
                  child: Opacity(
                    opacity: this.currentTab == HomePageTab.ACTIVE ? 1.0 : 0.4,
                    child: SvgPicture.asset('assets/svg/chat-icon.svg'),
                  ),
                ),
                SizedBox(width: SpacingValues.medium),
                Pressable(
                  onPressed: () {
                    if (this.currentTab != HomePageTab.ARCHIVED) {
                      this.onTabPressed(HomePageTab.ARCHIVED);
                    }
                  },
                  width: 44.0,
                  height: 44.0,
                  showInkwell: false,
                  child: Opacity(
                    opacity:
                        this.currentTab == HomePageTab.ARCHIVED ? 1.0 : 0.4,
                    child: SvgPicture.asset('assets/svg/archive-icon.svg',
                        height: 40.0, color: Colors.white),
                  ),
                ),
                SizedBox(width: SpacingValues.medium),
                Pressable(
                  onPressed: () {
                    if (this.currentTab != HomePageTab.TRASHED) {
                      this.onTabPressed(HomePageTab.TRASHED);
                    }
                  },
                  width: 34.0,
                  height: 44.0,
                  showInkwell: false,
                  child: Opacity(
                    opacity: this.currentTab == HomePageTab.TRASHED ? 1.0 : 0.4,
                    child: SvgPicture.asset('assets/svg/trash.svg',
                        height: 35.0, color: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 40.0,
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
                SizedBox(width: SpacingValues.extraSmall),
                HeaderOptionsButton(
                  diameter: 44.0,
                  isVertical: true,
                  onPressed: this.onOptionSelected,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
