import 'package:delphis_app/graphql/queries.dart';
import 'package:delphis_app/models/discussion.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'discussion_post.dart';

class DelphisDiscussion extends StatelessWidget {
  final String discussionID;

  const DelphisDiscussion({
    this.discussionID,
  }): super();

  @override
  Widget build(BuildContext context) {
    final query = SingleDiscussionGQLQuery(discussionID: this.discussionID);
    return Query(
      options: QueryOptions(
        documentNode: gql(query.query()),
        variables: {
          'id': this.discussionID,
        },
      ),
      builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
        if (result.hasException) {
          return Text(result.exception.toString());
        } else if (result.loading) {
          return Text(Intl.message('Loading...'));
        }
        var discussionObj = query.parseResult(result.data);
        print(discussionObj.title);
        return Scaffold(
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
          body: ListView.builder(
            key: Key('discussion-posts-' + this.discussionID),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: discussionObj.posts.length,
            itemBuilder: (context, index) {
              return DiscussionPost(discussion: discussionObj, index: index);
            }
          )
        );
      },
    );
  }
}