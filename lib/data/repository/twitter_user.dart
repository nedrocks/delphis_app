import 'package:delphis_app/bloc/gql_client/gql_client_bloc.dart';
import 'package:delphis_app/data/provider/queries.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:json_annotation/json_annotation.dart' as JsonAnnotation;

part 'twitter_user.g.dart';

const MAX_ATTEMPTS = 3;
const BACKOFF = 1;

class TwitterUserRepository {
  final GqlClientBloc clientBloc;

  const TwitterUserRepository({
    @required this.clientBloc,
  });

  Future<List<TwitterUserInfo>> getUserInfoAutocompletes(
      String query, String discussionID, String invitingParticipantID,
      {int attempt = 1}) async {
    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return getUserInfoAutocompletes(
            query, discussionID, invitingParticipantID,
            attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          "Failed to get Twitter user autocompletes because backend connection is severed");
    }
    final gqlQuery = TwitterUserAutocompletesQuery(
      queryParam: query,
      discussionID: discussionID,
      invitingParticipantID: invitingParticipantID,
    );

    final QueryResult result = await client.query(
      QueryOptions(
        documentNode: gql(gqlQuery.query()),
        variables: {
          'query': gqlQuery.queryParam,
          'discussionID': gqlQuery.discussionID,
          'invitingParticipantID': gqlQuery.invitingParticipantID
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      print(result.exception.clientException);
      throw result.exception;
    }
    return gqlQuery.parseResult(result.data);
  }
}

@JsonAnnotation.JsonSerializable()
class TwitterUserInfo extends Equatable {
  final String id;
  final String name;
  final String displayName;
  final String profileImageURL;
  final bool verified;
  final bool invited;

  const TwitterUserInfo(
      {this.id,
      this.name,
      this.displayName,
      this.profileImageURL,
      this.verified,
      this.invited});

  List<Object> get props =>
      [id, name, displayName, profileImageURL, verified, invited];

  factory TwitterUserInfo.fromJson(Map<String, dynamic> json) =>
      _$TwitterUserInfoFromJson(json);

  Map<String, dynamic> toJSON() {
    return _$TwitterUserInfoToJson(this);
  }
}

@JsonAnnotation.JsonSerializable()
class TwitterUserInput extends Equatable {
  final String name;

  const TwitterUserInput({
    @required this.name,
  });

  List<Object> get props => [name];

  Map<String, dynamic> toJSON() {
    return _$TwitterUserInputToJson(this);
  }
}
