import 'package:delphis_app/data/provider/queries.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:json_annotation/json_annotation.dart' as JsonAnnotation;

import 'participant.dart';
import 'user_profile.dart';
import 'viewer.dart';

part 'user.g.dart';

class UserRepository {
  final GraphQLClient client;

  const UserRepository(this.client);

  Future<User> getMe() async {
    final query = MeGQLQuery();

    final QueryResult result = await client.query(
      QueryOptions(
        documentNode: gql(query.query()),
        variables: {}
      )
    );

    if (result.hasException) {
      throw result.exception;
    }
    return query.parseResult(result.data);
  }
}

@JsonAnnotation.JsonSerializable()
class User extends Equatable {
  final String id;
  final List<Participant> participants;
  final List<Viewer> viewers;
  final UserProfile profile;

  List<Object> get props => [
    id, participants, viewers, profile
  ];

  const User({
    this.id,
    this.participants,
    this.viewers,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}