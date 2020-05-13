import 'package:delphis_app/bloc/gql_client/gql_client_bloc.dart';
import 'package:delphis_app/data/provider/mutations.dart';
import 'package:delphis_app/data/provider/queries.dart';
import 'package:delphis_app/data/provider/subscriptions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:json_annotation/json_annotation.dart' as JsonAnnotation;

import 'moderator.dart';
import 'participant.dart';
import 'post.dart';

part 'discussion.g.dart';

const MAX_ATTEMPTS = 3;
const BACKOFF = 1;

enum AnonymityType { UNKNOWN, WEAK, STRONG }

class DiscussionRepository {
  final GqlClientBloc clientBloc;

  const DiscussionRepository({
    @required this.clientBloc,
  });

  Future<Discussion> getDiscussion(String discussionID,
      {int attempt = 1}) async {
    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return getDiscussion(discussionID, attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          "Failed to get discussion because backend connection is severed");
    }

    final query = SingleDiscussionGQLQuery();

    final QueryResult result = await client.query(QueryOptions(
      documentNode: gql(query.query()),
      variables: {
        'id': discussionID,
      },
    ));
    // Handle exceptions
    if (result.hasException) {
      throw result.exception;
    }
    return query.parseResult(result.data);
  }

  Future<Post> addPost(String discussionID, String postContent,
      {int attempt = 1}) async {
    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return addPost(discussionID, postContent, attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          "Failed to addPost to discussion because backend connection is severed");
    }

    final mutation = AddPostGQLMutation(
        discussionID: discussionID, postContent: postContent);
    final QueryResult result = await client.mutate(
      MutationOptions(
        documentNode: gql(mutation.mutation()),
        variables: {
          'discussionId': discussionID,
          'postContent': postContent,
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

  Future<Stream<Post>> subscribe(String discussionID, {int attempt = 1}) async {
    final websocketClient = this.clientBloc.getWebsocketClient();

    if (websocketClient == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return subscribe(discussionID, attempt: attempt + 1);
      });
    } else if (websocketClient == null) {
      throw Exception(
          "Failed to get discussion because backend connection is severed");
    }
    final subscription = PostAddedSubscription(discussionID);
    Stream<SubscriptionData> resStream = websocketClient.subscribe(
      SubscriptionRequest(Operation(
          operationName: "postAdded",
          documentNode: gql(subscription.subscription()),
          variables: {
            'discussionID': discussionID,
          })),
      true,
    );

    return resStream.map<Post>((SubscriptionData res) {
      if (res.errors != null) {
        throw Exception("Caught errors from GQL subcription: ${res.errors}");
      }
      return subscription.parseResult(res.data);
    });
  }
}

@JsonAnnotation.JsonSerializable()
class Discussion extends Equatable {
  final String id;
  final Moderator moderator;
  final AnonymityType anonymityType;
  final List<Post> posts;
  final List<Participant> participants;
  final String title;
  final String createdAt;
  final String updatedAt;
  final Participant meParticipant;

  @override
  List<Object> get props => [
        id,
        moderator,
        anonymityType,
        posts,
        participants,
        title,
        createdAt,
        updatedAt,
        meParticipant,
      ];

  const Discussion({
    this.id,
    this.moderator,
    this.anonymityType,
    this.posts,
    this.participants,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.meParticipant,
  });

  factory Discussion.fromJson(Map<String, dynamic> json) =>
      _$DiscussionFromJson(json);

  Discussion copyWith({
    List<Post> posts,
    Participant meParticipant,
  }) =>
      Discussion(
        id: this.id,
        moderator: this.moderator,
        anonymityType: this.anonymityType,
        participants: this.participants,
        title: this.title,
        createdAt: this.createdAt,
        updatedAt: this.updatedAt,
        posts: posts ?? this.posts,
        meParticipant: meParticipant ?? this.meParticipant,
      );

  Participant getParticipantForPostIdx(int idx) {
    if (idx < 0 || idx >= this.posts.length) {
      print('index is above post length');
      return null;
    }
    final post = this.posts[idx];
    return this.participants.firstWhere(
        (participant) =>
            participant.participantID == post.participant.participantID,
        orElse: () => null);
  }
}
