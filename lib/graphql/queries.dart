import 'package:delphis_app/models/discussion.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:delphis_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// abstract class GQLQuery<T> extends StatelessWidget {
//   final Map<String, dynamic> variables;
//   final Widget children;

//   const GQLQuery({
//     this.variables,
//     this.children,
//   }): super();

//   @protected
//   T parseResult(dynamic data);
// }

// abstract class GQLMutation<T> extends StatelessWidget {
//   @protected
//   T parseResult(dynamic data);
//   String mutation(Map variables);
// }

abstract class GQLQuery<T> {
  T parseResult(dynamic data);
  String query();

  const GQLQuery();
}

class MeGQLQuery extends GQLQuery<User>{
  final String _query = """
    query Me() {
      me {
        id
        profile {
          id
          displayName
          profileImageURL
        }
      }
    }
  """;

  const MeGQLQuery(): super();

  String query() {
    return this._query;
  }

  User parseResult(dynamic data) {
    return User.fromJson(data["me"]);
  }
}

class SingleDiscussionGQLQuery extends GQLQuery<Discussion>{
  final String discussionID;
  final String _query = """
    query Discussion(\$id: ID!) {
      discussion(id: \$id){
        id
        moderator {
          id
          userProfile {
            id
            displayName
            twitterURL {
              displayText
              url
            }
          }
        }
        anonymityType
        posts {
          id
          content
          participant {
            participantID
          }
          isDeleted
          createdAt
          updatedAt
        }
        title
      }
    }
  """;

  const SingleDiscussionGQLQuery({
    this.discussionID,
  }): super();

  String query() {
    return this._query;
  }

  Discussion parseResult(dynamic data) {
    return Discussion.fromJson(data["discussion"]);
  }
}

class DiscussionsGQLQuery extends GQLQuery<Discussion>{
  final String _query = """
    query Discussions() {
      listDiscussions {
        id
        title
        moderator {
          id
          userProfile {
            id
            displayName
            twitterURL {
              displayText
              url
            }
          }
        }
        anonymityType
      }
    }
  """;

  const DiscussionsGQLQuery(): super();

  String query() {
    return this._query;
  }

  // TODO: This is wrong -- needs to be a list.
  Discussion parseResult(dynamic data) {
    return Discussion.fromJson(data["listDiscussions"]);
  }
}