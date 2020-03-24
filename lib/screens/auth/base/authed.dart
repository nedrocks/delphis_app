import 'package:delphis_app/graphql/queries.dart';
import 'package:delphis_app/screens/discussion/discussion.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

class DelphisAuthedBaseView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DelphisDiscussion(discussionID: '492ace75-8eac-4345-9aa4-403661e85b31');
    // return Scaffold(
    //   body: Center(
    //       child: Container(
    //         color: Colors.white,
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             Query(
    //               options: QueryOptions(
    //                 documentNode: gql(DiscussionsGQLQuery().query()),
    //                 variables: {},
    //               ),
    //               builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
    //                 if (result.hasException) {
    //                   return Text(result.exception.toString());
    //                 }

    //                 if (result.loading) {
    //                   return Text(Intl.message('Loading...'));
    //                 }

    //                 return Text('Discussions: ${result.data}');
    //               }
    //             )
    //           ]
    //         ),
    //       ),
    //   ),
    // );
  }
}