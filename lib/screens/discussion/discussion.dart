import 'package:delphis_app/graphql/queries.dart';
import 'package:delphis_app/screens/discussion/overlay/animated_discussion_popup.dart';
import 'package:delphis_app/screens/discussion/overlay/gone_incognito_popup_contents.dart';
import 'package:delphis_app/widgets/input/delphis_input.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import 'discussion_post.dart';
import 'overlay/discussion_popup.dart';

class DelphisDiscussion extends StatefulWidget {
  final String discussionID;

  const DelphisDiscussion({
    this.discussionID,
  }): super();

  @override
  State<StatefulWidget> createState() => DelphisDiscussionState();
}

class DelphisDiscussionState extends State<DelphisDiscussion> {
  bool hasAcceptedIncognitoWarning;

  @override
  void initState() {
    super.initState();

    this.hasAcceptedIncognitoWarning = false;
  }

  @override
  Widget build(BuildContext context) {
    final query = SingleDiscussionGQLQuery(discussionID: this.widget.discussionID);
    return Query(
      options: QueryOptions(
        documentNode: gql(query.query()),
        variables: {
          'id': this.widget.discussionID,
        },
      ),
      builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
        if (result.hasException) {
          return Text(result.exception.toString());
        } else if (result.loading) {
          return Text(Intl.message('Loading...'));
        }
        var discussionObj = query.parseResult(result.data);
        var listViewBuilder = Container(
          child: ListView.builder(
            key: Key('discussion-posts-' + this.widget.discussionID),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: discussionObj.posts.length,
            itemBuilder: (context, index) {
              return DiscussionPost(discussion: discussionObj, index: index);
            }
          ),
          height: double.infinity,
        );
        var listViewWithInput = Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            listViewBuilder,
            DelphisInput(discussionId: this.widget.discussionID),
          ],
        );
        Widget toRender = listViewWithInput;
        if (!this.hasAcceptedIncognitoWarning) {
          toRender = AnimatedDiscussionPopup(
            child: listViewWithInput,
            popup: DiscussionPopup(
              contents: GoneIncognitoDiscussionPopupContents(
                moderator: discussionObj.moderator.userProfile,
                onAccept: () {
                  this.setState(() => this.hasAcceptedIncognitoWarning = true);
                },
              ),
            ),
            animationSeconds: 0,
          );
        }
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text(
                discussionObj.title,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.black,
            ),
            backgroundColor: Colors.black,
            body: toRender,
          )
        );
      },
    );
  }
}