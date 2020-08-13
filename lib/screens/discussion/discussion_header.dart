import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/screens/discussion/discussion_header_notification.dart';
import 'package:delphis_app/screens/discussion/header_options_button.dart';
import 'package:delphis_app/screens/discussion/participants_button.dart';
import 'package:delphis_app/widgets/discussion_icon/discussion_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DiscussionHeader extends StatefulWidget {
  final Discussion discussion;
  final HeaderOptionsCallback onHeaderOptionSelected;
  final VoidCallback onBackButtonPressed;
  final VoidCallback onParticipantsButtonPressed;

  const DiscussionHeader({
    @required this.discussion,
    @required this.onHeaderOptionSelected,
    @required this.onBackButtonPressed,
    @required this.onParticipantsButtonPressed,
  }) : super();

  @override
  _DiscussionHeaderState createState() => _DiscussionHeaderState();
}

class _DiscussionHeaderState extends State<DiscussionHeader>
    with SingleTickerProviderStateMixin {
  bool isMultilineTile;
  bool isFirstBuild;

  @override
  void initState() {
    this.isMultilineTile = true;
    this.isFirstBuild = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstBuild) {
      setState(() {
        isFirstBuild = false;
        Future.delayed(Duration(milliseconds: 2000), () {
          if (this.mounted) {
            setState(() {
              isMultilineTile = false;
            });
          }
        });
      });
    }
    return AnimatedSize(
      vsync: this,
      duration: Duration(milliseconds: 200),
      reverseDuration: Duration(milliseconds: 50),
      curve: Curves.decelerate,
      child: Column(
        children: [
          Container(
            height: this.isMultilineTile ? null : HeightValues.appBarHeight,
            padding: EdgeInsets.only(right: SpacingValues.mediumLarge),
            decoration: BoxDecoration(
              border: Border(
                  bottom:
                      BorderSide(color: Color.fromRGBO(151, 151, 151, 0.4))),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    this.widget.onBackButtonPressed();
                  },
                  child: Row(
                    children: [
                      SizedBox(width: SpacingValues.mediumLarge),
                      Container(
                        height: HeightValues.appBarHeight,
                        child: SvgPicture.asset('assets/svg/back_chevron.svg',
                            color: Color.fromRGBO(81, 82, 88, 1.0)),
                      ),
                      SizedBox(width: SpacingValues.small),
                    ],
                  ),
                ),
                DiscussionIcon(
                  height: HeightValues.appBarItemsHeight,
                  width: HeightValues.appBarItemsHeight,
                  imageURL: this.widget.discussion.iconURL,
                ),
                SizedBox(width: SpacingValues.extraSmall),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        this.isMultilineTile = !this.isMultilineTile;
                      });
                      return true;
                    },
                    child: Container(
                      margin: this.isMultilineTile
                          ? EdgeInsets.symmetric(vertical: 6.5, horizontal: 0)
                          : null,
                      child: Text(this.widget.discussion.title,
                          style: Theme.of(context).textTheme.headline1,
                          overflow: this.isMultilineTile
                              ? null
                              : TextOverflow.ellipsis),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: SpacingValues.medium),
                    ParticipantsButton(
                      diameter: HeightValues.appBarItemsHeight,
                      onPressed: this.widget.onParticipantsButtonPressed,
                    ),
                  ],
                ),
              ],
            ),
          ),
          DiscussionHeaderNotification(),
        ],
      ),
    );
  }
}
