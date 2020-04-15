import 'package:delphis_app/data/provider/muatations.dart';
import 'package:delphis_app/data/provider/queries.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:json_annotation/json_annotation.dart' as JsonAnnotation;

import 'moderator.dart';
import 'participant.dart';
import 'post.dart';

part 'discussion.g.dart';

enum AnonymityType {
  UNKNOWN,
  WEAK,
  STRONG
}

class DiscussionRepository {
  final GraphQLClient client;

  const DiscussionRepository(
    this.client,
  );

  Future<Discussion> getDiscussion(String discussionId) async {
    final query = SingleDiscussionGQLQuery();

    final QueryResult result = await client.query(
      QueryOptions(
        documentNode: gql(query.query()),
        variables: {
          'id': discussionId,
        },
      )
    );
    // Handle exceptions
    if (result.hasException) {
      throw result.exception;
    }
    return query.parseResult(result.data);
  }

  Future<Post> addPost(String discussionID, String postContent) async {
    final mutation = AddPostGQLMutation(discussionID: discussionID, postContent: postContent);
    final QueryResult result = await client.mutate(
      MutationOptions(
        documentNode: gql(mutation.mutation()),
        variables: {
          'discussionId': discussionID,
          'postContent': postContent,
        },
        update: (Cache cache, QueryResult result) {
          // TODO: Update the cache somehow?
          return cache;
        },
      ),
    );

    if (result.hasException) {
      throw result.exception;
    }
    return mutation.parseResult(result.data);
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

  @override
  List<Object> get props => [
    id, moderator, anonymityType, posts, participants, title, createdAt, updatedAt
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
  });

  factory Discussion.fromJson(Map<String, dynamic> json) => _$DiscussionFromJson(json);

  Discussion copyWith({
    List<Post> posts,
  }) => Discussion(
    id: this.id,
    moderator: this.moderator,
    anonymityType: this.anonymityType,
    participants: this.participants,
    title: this.title,
    createdAt: this.createdAt,
    updatedAt: this.updatedAt,

    posts: posts ?? this.posts,
  );
}