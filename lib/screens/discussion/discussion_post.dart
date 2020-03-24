import 'package:delphis_app/models/discussion.dart';
import 'package:flutter/material.dart';

class DiscussionPost extends StatelessWidget {
  final Discussion discussion;
  final int index;

  const DiscussionPost({
    this.discussion,
    this.index,
  }): super();

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var difference = now.difference(this.discussion.posts[this.index].createdAtAsDateTime());
    var differenceToDisplay = '${difference.inMinutes}m';
    if (difference.inMinutes > 60) {
      differenceToDisplay = '${difference.inHours}h';
      if (difference.inHours > 24) {
        differenceToDisplay = '${difference.inDays}d';
        if (difference.inDays > 30) {
          differenceToDisplay = '>30d';
        }
      }
    }
    return Container(
      padding: EdgeInsets.only(top: 8.0, left: 10.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.person_outline, color: Colors.white),
          ),
          Expanded(child: new Container(
            padding: EdgeInsets.only(top: 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: new Row(
                    children: <Widget>[
                      RichText(
                        text: new TextSpan(
                          children: <WidgetSpan>[
                            WidgetSpan(
                              child: Text('Anonymous something', style: new TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.w300)),
                            ),
                            WidgetSpan(
                              child: Container(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(differenceToDisplay, style: new TextStyle(fontSize: 12.0, color: Colors.grey, fontWeight: FontWeight.w300)),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 16.0, top: 4.0),
                        child: Text(
                          '${this.discussion.posts[this.index].content}${this.discussion.posts[this.index].content}${this.discussion.posts[this.index].content}',
                          style: TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.w500, 
                            fontSize: 14.0,
                            height: 1.0,
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