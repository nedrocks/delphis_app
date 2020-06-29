import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/widgets/discussion_icon/discussion_icon.dart';
import 'package:flutter/material.dart';

class DiscussionMentionHintWidget extends StatelessWidget {
  final Discussion discussion;
  final VoidCallback onTap;

  DiscussionMentionHintWidget({
    @required this.discussion,
    this.onTap
  });
  
  @override
  Widget build(BuildContext context) {
    Widget discussionIcon = DiscussionIcon(
        width: 32, height: 32, imageURL: this.discussion.iconURL);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if(this.onTap != null)
            this.onTap();
          return true;
        },
        child: Container(
          height: 48,
          padding: EdgeInsets.all(SpacingValues.small),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              discussionIcon,
              SizedBox(width: SpacingValues.small),
              Expanded(
                child: Text(
                  this.discussion.title,
                  style: TextThemes.discussionTitleChatTab,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}