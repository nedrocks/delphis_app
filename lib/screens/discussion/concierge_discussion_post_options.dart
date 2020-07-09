import 'package:delphis_app/data/repository/concierge_content.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:delphis_app/data/repository/post_content_input.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/discussion/discussion_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ConciergeDiscussionPostOptions extends StatelessWidget {
  final Post post;
  final Participant participant;
  final ConciergePostOptionPressed onConciergeOptionPressed;

  const ConciergeDiscussionPostOptions({
    @required this.participant,
    @required this.post,
    @required this.onConciergeOptionPressed,
  }) : super();

  void _handleButtonPress(ConciergeOption option) {
    this.onConciergeOptionPressed(post, post.conciergeContent, option);
  }

  @override
  Widget build(BuildContext context) {
    if (post.postType != PostType.CONCIERGE) {
      return Container(width: 0, height: 0);
    }
    
    List<Widget> buttons = post.conciergeContent.options
        .map<RaisedButton>((option) => RaisedButton(
          padding: EdgeInsets.symmetric(
            horizontal: SpacingValues.xxLarge,
            vertical: SpacingValues.small,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0)
          ),
          onPressed: () {
            _handleButtonPress(option);
          },
          color: option.selected
            ? Color.fromRGBO(227, 227, 237, 1.0)
            : Color.fromRGBO(57, 58, 63, 1.0),
          child: Container(
            width: double.infinity,
            child: Row(
              children: [
                option.selected
                  ? SvgPicture.asset(
                      'assets/svg/check_mark.svg',
                      color: TextThemes.conciergeOptionSelectedText.color,
                      semanticsLabel: 'Selected',
                      width: TextThemes.conciergeOptionSelectedText.fontSize,
                    )
                  : SizedBox(width: TextThemes.conciergeOptionSelectedText.fontSize),
                SizedBox(width: SpacingValues.small),
                Expanded(
                  child: Text(
                    option.text,
                    style: option.selected
                      ? TextThemes.conciergeOptionSelectedText
                      : TextThemes.conciergeOptionUnSelectedText,
                    maxLines: 2,
                  ),
                )
              ],
            ),
          ),
        ))
        .toList();

    return Column(
      children: buttons,
    );
  }
}
