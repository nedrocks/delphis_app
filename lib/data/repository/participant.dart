import 'package:delphis_app/bloc/gql_client/gql_client_bloc.dart';
import 'package:delphis_app/data/provider/mutations.dart';
import 'package:delphis_app/data/provider/queries.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:json_annotation/json_annotation.dart' as JsonAnnotation;

import 'discussion.dart';
import 'flair.dart';
import 'post.dart';
import 'viewer.dart';
import 'entity.dart';

part 'participant.g.dart';

const MAX_ATTEMPTS = 3;
const BACKOFF = 1;

class ParticipantRepository {
  final GqlClientBloc clientBloc;

  const ParticipantRepository({@required this.clientBloc});

  Future<List<Participant>> getParticipantsForDiscussion(String discussionID,
      {int attempt = 1}) async {
    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return getParticipantsForDiscussion(discussionID, attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          "Failed to get discussion because backend connection is severed");
    }

    final query = ParticipantsForDiscussionQuery(discussionID: discussionID);

    final QueryResult result = await client.query(QueryOptions(
      documentNode: gql(query.query()),
      variables: {
        'id': discussionID,
      },
    ));

    if (result.hasException) {
      throw result.exception;
    }
    return query.parseResult(result.data);
  }

  Future<Participant> updateParticipant(
      {@required String discussionID,
      @required String participantID,
      GradientName gradientName,
      Flair flair,
      bool isAnonymous = false,
      bool isUnsetFlairID = false,
      bool isUnsetGradient = false,
      int attempt = 1}) async {
    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return updateParticipant(
            discussionID: discussionID,
            participantID: participantID,
            gradientName: gradientName,
            flair: flair,
            isAnonymous: isAnonymous,
            isUnsetFlairID: isUnsetFlairID,
            isUnsetGradient: isUnsetGradient,
            attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          "Failed to get discussion because backend connection is severed");
    }

    final mutation = UpdateParticipantGQLMutation(
        discussionID: discussionID,
        participantID: participantID,
        gradientName: gradientName,
        flair: flair,
        isAnonymous: isAnonymous,
        isUnsetFlairID: isUnsetFlairID,
        isUnsetGradient: isUnsetGradient);
    final QueryResult result = await client.mutate(
      MutationOptions(
        documentNode: gql(mutation.mutation()),
        variables: {
          'discussionID': discussionID,
          'participantID': participantID,
          'updateInput': mutation.createInputObject(),
        },
        update: (Cache cache, QueryResult result) {
          return cache;
        },
      ),
    );

    if (result.hasException) {
      throw result.exception;
    }

    return mutation.parseResult(result.data);
  }

  Future<Participant> participantJoinedDiscussion(
      {@required String discussionID,
      @required String participantID,
      int attempt = 1}) async {
    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return participantJoinedDiscussion(
            discussionID: discussionID,
            participantID: participantID,
            attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          "Failed to get discussion because backend connection is severed");
    }
    final mutation = UpdateParticipantGQLMutation(
        discussionID: discussionID,
        participantID: participantID,
        hasJoined: true);
    final QueryResult result = await client.mutate(
      MutationOptions(
        documentNode: gql(mutation.mutation()),
        variables: {
          'discussionID': discussionID,
          'participantID': participantID,
          'updateInput': mutation.createInputObject(),
        },
        update: (Cache cache, QueryResult result) {
          return cache;
        },
      ),
    );

    if (result.hasException) {
      throw result.exception;
    }

    return mutation.parseResult(result.data);
  }

  Future<Participant> addDiscussionParticipant(
      String discussionID,
      String userID,
      String gradientColor,
      String flairID,
      bool hasJoined,
      bool isAnonymous,
      {int attempt = 1}) async {
    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return addDiscussionParticipant(discussionID, userID, gradientColor,
            flairID, hasJoined, isAnonymous,
            attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          "Failed to get discussion because backend connection is severed");
    }
    final mutation = AddDiscussionParticipantGQLMutation(
      discussionID: discussionID,
      userID: userID,
      gradientColor: gradientColor,
      flairID: flairID,
      hasJoined: hasJoined,
      isAnonymous: isAnonymous,
    );
    final QueryResult result = await client.mutate(
      MutationOptions(
          documentNode: gql(mutation.mutation()),
          variables: {
            'discussionID': discussionID,
            'userID': userID,
            'discussionParticipantInput': mutation.createInputObject(),
          },
          update: (Cache cache, QueryResult result) {
            return cache;
          }),
    );

    if (result.hasException) {
      throw result.exception;
    }

    return mutation.parseResult(result.data);
  }
}

@JsonAnnotation.JsonSerializable()
class Participant extends Equatable implements Entity {
  final String id;
  final int participantID;
  final Discussion discussion;
  final Viewer viewer;
  final List<Post> posts;
  final bool isAnonymous;
  final String gradientColor;
  final Flair flair;
  final bool hasJoined;

  List<Object> get props =>
      [participantID, discussion, viewer, posts, flair, hasJoined];

  const Participant({
    this.id,
    this.participantID,
    this.discussion,
    this.viewer,
    this.posts,
    this.isAnonymous,
    this.gradientColor,
    this.flair,
    this.hasJoined,
  });

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);
  
  Map<String, dynamic> toJSON() {
    return _$ParticipantToJson(this);
  }

  static String getNameInDiscussion(Discussion discussion, Participant participant) {
    var name = '${participant.gradientColor} ${participant.participantID}';
    if (participant.participantID == 0) {
      name = discussion.moderator.userProfile.displayName;
    }
    return name;
  }

  static String getUniqueNameInDiscussion(Discussion discussion, Participant participant) {
    // TODO: this has to be changed when proper naming is implemented. Would be cool
    // to encapsulate the naming logic in a single class in order to be consistent.
    var name = '${participant.gradientColor} ${participant.participantID}';
    if (participant.participantID == 0) {
      name = discussion.moderator.userProfile.displayName + ' ${participant.participantID}';
    }
    return name;
  }

}
