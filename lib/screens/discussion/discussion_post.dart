import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:flutter/material.dart';

import 'post_title.dart';

class DiscussionPost extends StatelessWidget {
  final Discussion discussion;
  final int index;

  const DiscussionPost({
    this.discussion,
    this.index,
  }): super();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: SpacingValues.medium, 
        bottom: SpacingValues.extraLarge
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: SpacingValues.medium),
            child: Icon(Icons.person_outline, color: Colors.white),
          ),
          Expanded(child: Container(
            padding: EdgeInsets.only(
              top: SpacingValues.extraSmall, 
              right: SpacingValues.xxLarge
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PostTitle(discussion: this.discussion, index: this.index),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: SpacingValues.extraSmall),
                        child: Text(
                          '${this.discussion.posts[this.index].content}',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}