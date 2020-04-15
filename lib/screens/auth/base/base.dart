import 'package:delphis_app/data/provider/queries.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:delphis_app/data/repository/auth.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'authed.dart';
import 'unauthed.dart';

class DelphisBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Intl.message("Delphis App")),
        actions: <Widget>[
          Query(
            options: QueryOptions(
              documentNode: gql(MeGQLQuery().query()),
              variables: {},
            ),
            builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
              if (result.hasException) {
                return Container(width: 0.0, height: 0.0);
              }

              if (result.loading) {
                return Container(width: 0.0, height: 0.0);
              }

              var userObj = MeGQLQuery().parseResult(result.data);

              return Container(
                padding: EdgeInsets.all(8.0),
                child:ConstrainedBox(
                  constraints: BoxConstraints.loose(Size(30.0, 30.0)),
                  child: FlatButton(
                    onPressed: null,
                    padding: EdgeInsets.all(0.0),
                    child: Image.network(userObj.profile.profileImageURL),
                  ),
                ),
              );
            },
          ),
        ],
      ), 
      body: Consumer<DelphisAuthRepository>(
        builder: (context, authModel, child) {
          if (!authModel.isAuthed) {
            return DelphisUnauthedBaseView();
          }
          return DelphisAuthedBaseView();
        },
      ),
    );
  }
}