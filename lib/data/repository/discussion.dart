import 'package:delphis_app/bloc/gql_client/gql_client_bloc.dart';
import 'package:delphis_app/data/provider/mutations.dart';
import 'package:delphis_app/data/provider/queries.dart';
import 'package:delphis_app/data/provider/subscriptions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:json_annotation/json_annotation.dart' as JsonAnnotation;

import 'moderator.dart';
import 'participant.dart';
import 'post.dart';
import 'post_content_input.dart';

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

  Future<Post> addPost(
      {@required String discussionID,
      @required String participantID,
      @required String postContent,
      int attempt = 1}) async {
    if (postContent == null || postContent.length == 0) {
      // Don't allow for empty posts.
      return null;
    }

    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return addPost(
            discussionID: discussionID,
            participantID: participantID,
            postContent: postContent,
            attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          "Failed to addPost to discussion because backend connection is severed");
    }

    final mutation = AddPostGQLMutation(
      discussionID: discussionID,
      participantID: participantID,
      postContent: PostContentInput(
        postText: postContent,
        postType: PostType.TEXT,
      ),
    );
    final QueryResult result = await client.mutate(
      MutationOptions(
        documentNode: gql(mutation.mutation()),
        variables: {
          'discussionID': discussionID,
          'participantID': participantID,
          'postContent': mutation.postContent.toJSON(),
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
  final List<Participant> meAvailableParticipants;

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
        meAvailableParticipants,
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
    this.meAvailableParticipants,
  });

  factory Discussion.fromJson(Map<String, dynamic> json) =>
      _$DiscussionFromJson(json);

  Discussion copyWith({
    List<Post> posts,
    Participant meParticipant,
    List<Participant> participants,
    List<Participant> meAvailableParticipants,
    Moderator moderator,
  }) =>
      Discussion(
        id: this.id,
        moderator: moderator ?? this.moderator,
        anonymityType: this.anonymityType,
        participants: participants ?? this.participants,
        title: this.title,
        createdAt: this.createdAt,
        updatedAt: this.updatedAt,
        posts: posts ?? this.posts,
        meParticipant: meParticipant ?? this.meParticipant,
        meAvailableParticipants:
            meAvailableParticipants ?? this.meAvailableParticipants,
      );

  void addLocalPost(LocalPost post) {
    this.posts.insert(0, post.post);
  }

  bool replaceLocalPost(Post withPost, GlobalKey localPostKey) {
    final keyAsString = localPostKey.toString();
    for (int i = 0; i < this.posts.length; i++) {
      final post = this.posts[i];
      if ((post.isLocalPost ?? false) && post.id == keyAsString) {
        this.posts[i] = withPost;
        return true;
      }
    }
    return false;
  }

  Participant getParticipantForPostIdx(int idx) {
    if (idx < 0 || idx >= this.posts.length) {
      return null;
    }
    final post = this.posts[idx];
    var participant = this.participants.firstWhere(
        (participant) =>
            participant.participantID == post.participant.participantID,
        orElse: () => null);
    if (participant == null) {
      // Not sure what to do here.
    }
    return participant;
  }
}
