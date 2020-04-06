import 'package:delphis_app/models/discussion.dart';
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
      padding: EdgeInsets.only(top: 8.0, left: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.person_outline, color: Colors.white),
          ),
          Expanded(child: Container(
            padding: EdgeInsets.only(top: 4.0, right: 30.0),
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
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(
                          '${this.discussion.posts[this.index].content}',
                          style: TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.w500, 
                            fontSize: 14.0,
                            height: 1.25,
                          ),
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