import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:json_annotation/json_annotation.dart' as JsonAnnotation;

import 'package:delphis_app/bloc/gql_client/gql_client_bloc.dart';
import 'package:delphis_app/data/provider/mutations.dart';
import 'package:delphis_app/data/provider/queries.dart';
import 'package:delphis_app/data/provider/subscriptions.dart';
import 'package:delphis_app/data/repository/discussion_access.dart';
import 'package:delphis_app/data/repository/discussion_creation_settings.dart';
import 'package:delphis_app/data/repository/discussion_subscription.dart';
import 'package:delphis_app/data/repository/historical_string.dart';
import 'package:delphis_app/data/repository/viewer.dart';

import 'entity.dart';
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

  Future<ListDiscussionsResponse> getDiscussionList({int attempt = 1}) async {
    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return getDiscussionList(attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          'Failed to list discussions because connection is severed');
    }

    final query = ListDiscussionsGQLQuery();

    final QueryResult result = await client.query(
      QueryOptions(
        documentNode: gql(query.query()),
        variables: {},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      throw result.exception;
    }
    return query.parseResult(result.data);
  }

  Future<List<Discussion>> getMyDiscussionList({int attempt = 1}) async {
    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return getMyDiscussionList(attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          'Failed to list discussions because connection is severed');
    }

    final query = ListMyDiscussionsGQLQuery();

    final QueryResult result = await client.query(
      QueryOptions(
        documentNode: gql(query.query()),
        variables: {},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      throw result.exception;
    }
    return query.parseResult(result.data);
  }

  Future<Post> selectConciergeMutation(
      String discussionID, String mutationID, List<String> selectedOptionIDs,
      {int attempt = 1}) async {
    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return selectConciergeMutation(
            discussionID, mutationID, selectedOptionIDs,
            attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          "Failed to get discussion because backend connection is severed");
    }

    final mutation = ConciergeOptionMutation(
        discussionID: discussionID,
        mutationID: mutationID,
        selectedOptionIDs: selectedOptionIDs);

    final QueryResult result = await client.mutate(
      MutationOptions(
        documentNode: gql(mutation.mutation()),
        variables: {
          'discussionID': discussionID,
          'mutationID': mutationID,
          'selectedOptionIDs': selectedOptionIDs,
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

  Future<PostsConnection> getDiscussionPostsConnection(String discussionID,
      {PostsConnection postsConnection, int attempt = 1}) async {
    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return getDiscussionPostsConnection(discussionID,
            postsConnection: postsConnection, attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          "Failed to get discussion because backend connection is severed");
    }

    var after =
        postsConnection == null ? null : postsConnection.pageInfo.endCursor;
    final query = PostsConnectionForDiscussionQuery(
        discussionID: discussionID, after: after);

    final QueryResult result = await client.query(
      QueryOptions(
        documentNode: gql(query.query()),
        variables: {'id': discussionID, 'after': after},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      throw result.exception;
    }

    return query.parseResult(result.data);
  }

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
      fetchPolicy: FetchPolicy.noCache,
    ));
    // Handle exceptions
    if (result.hasException) {
      throw result.exception;
    }
    return query.parseResult(result.data);
  }

  Future<DiscussionUserAccess> updateDiscussionUserSettings(
      String discussionID,
      DiscussionUserAccessState accessState,
      DiscussionUserNotificationSetting setting,
      {int attempt = 1}) async {
    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return updateDiscussionUserSettings(discussionID, accessState, setting,
            attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          "Failed to get discussion because backend connection is severed");
    }

    final mutation = UpdateDiscussionUserSettingsMutation(
        discussionID: discussionID, state: accessState, notifSetting: setting);

    final QueryResult result = await client.mutate(
      MutationOptions(
        documentNode: gql(mutation.mutation()),
        variables: {
          'discussionID': discussionID,
          'settings': mutation.createInputObject()
        },
        update: (Cache cache, QueryResult result) {
          return cache;
        },
      ),
    );
    // Handle exceptions
    if (result.hasException) {
      throw result.exception;
    }
    return mutation.parseResult(result.data);
  }

  Future<Discussion> getDiscussionFromSlug(String slug,
      {int attempt = 1}) async {
    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return getDiscussionFromSlug(slug, attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          "Failed to get discussion because backend connection is severed");
    }

    final query = DiscussionFromDiscussionSlugQuery(slug: slug);

    final QueryResult result = await client.query(QueryOptions(
      documentNode: gql(query.query()),
      variables: {
        'slug': slug,
      },
      fetchPolicy: FetchPolicy.noCache,
    ));
    // Handle exceptions
    if (result.hasException) {
      throw result.exception;
    }
    return query.parseResult(result.data);
  }

  Future<Discussion> getDiscussionModOnlyFields(String discussionID,
      {int attempt = 1}) async {
    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return getDiscussionModOnlyFields(discussionID, attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          "Failed to get discussion because backend connection is severed");
    }

    final query = DiscussionModOnlyFieldsGQLQuery(discussionID: discussionID);

    final QueryResult result = await client.query(QueryOptions(
      documentNode: gql(query.query()),
      variables: {
        'id': discussionID,
      },
      fetchPolicy: FetchPolicy.noCache,
    ));
    // Handle exceptions
    if (result.hasException) {
      throw result.exception;
    }
    return query.parseResult(result.data);
  }

  Future<Discussion> createDiscussion({
    @required String title,
    @required String description,
    @required AnonymityType anonymityType,
    @required DiscussionCreationSettings creationSettings,
    int attempt = 1,
  }) async {
    if (title == null || title.length == 0) {
      return null;
    }

    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return createDiscussion(
          title: title,
          description: description,
          anonymityType: anonymityType,
          creationSettings: creationSettings,
          attempt: attempt + 1,
        );
      });
    } else if (client == null) {
      throw Exception(
          'Failed to createDiscussion because backend connection is severed');
    }

    final mutation = CreateDiscussionGQLMutation(
        anonymityType: anonymityType,
        title: title,
        description: description,
        creationSettings: creationSettings);

    final QueryResult result = await client.mutate(
      MutationOptions(
        documentNode: gql(mutation.mutation()),
        variables: {
          'anonymityType': anonymityType.toString().split('.')[1].toUpperCase(),
          'title': title,
          'description': description,
          'discussionSettings': mutation.createInputObject()
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

  Future<Discussion> joinDiscussionWithVIPLink(
      {@required String discussionID,
      @required String vipToken,
      int attempt = 1}) async {
    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return joinDiscussionWithVIPLink(
            discussionID: discussionID,
            vipToken: vipToken,
            attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          "Failed to addPost to discussion because backend connection is severed");
    }

    final mutation = JoinDiscussionWithVIPLinkMutation(
      discussionID: discussionID,
      vipToken: vipToken,
    );
    final QueryResult result = await client.mutate(
      MutationOptions(
        documentNode: gql(mutation.mutation()),
        variables: {
          'discussionID': discussionID,
          'vipToken': vipToken,
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

  Future<Post> addPost(
      {@required Discussion discussion,
      @required String participantID,
      @required String postContent,
      @required List<String> mentionedEntities,
      String preview,
      String mediaId,
      int attempt = 1}) async {
    if ((postContent == null || postContent.length == 0) &&
        (mediaId == null || mediaId.length == 0)) {
      // Don't allow for empty posts.
      return null;
    }

    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return addPost(
            discussion: discussion,
            participantID: participantID,
            postContent: postContent,
            mentionedEntities: mentionedEntities,
            preview: preview,
            mediaId: mediaId,
            attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          "Failed to addPost to discussion because backend connection is severed");
    }

    var postInputContent = PostContentInput(
        postText: postContent,
        postType: PostType.STANDARD,
        mentionedEntities: mentionedEntities,
        preview: preview,
        mediaID: mediaId);
    final mutation = AddPostGQLMutation(
      discussionID: discussion.id,
      participantID: participantID,
      postContent: postInputContent,
    );
    final QueryResult result = await client.mutate(
      MutationOptions(
        documentNode: gql(mutation.mutation()),
        variables: {
          'discussionID': discussion.id,
          'participantID': participantID,
          'postContent': postInputContent.toJSON(),
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

  Future<Post> deletePost(Discussion discussion, Post post,
      {int attempt = 1}) async {
    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return deletePost(discussion, post, attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          "Failed to deletePost from discussion because backend connection is severed");
    }

    final mutation =
        DeletePostMutation(discussionID: discussion.id, postID: post.id);
    final QueryResult result = await client.mutate(
      MutationOptions(
        documentNode: gql(mutation.mutation()),
        variables: {
          'discussionID': discussion.id,
          'postID': post.id,
        },
      ),
    );

    if (result.hasException) {
      throw result.exception;
    }
    return mutation.parseResult(result.data);
  }

  Future<Discussion> updateDiscussion(
    String discussionID,
    DiscussionInput input, {
    int attempt = 1,
  }) async {
    final client = this.clientBloc.getClient();

    if (client == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return updateDiscussion(discussionID, input, attempt: attempt + 1);
      });
    } else if (client == null) {
      throw Exception(
          'Failed to createDiscussion because backend connection is severed');
    }

    final mutation = UpdateDiscussionMutation(
      discussionID: discussionID,
      input: input,
    );

    final QueryResult result = await client.mutate(
      MutationOptions(
        documentNode: gql(mutation.mutation()),
        variables: {
          'discussionID': discussionID,
          'input': mutation.createInputObject(),
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

  Future<Stream<DiscussionSubscriptionEvent>> subscribe(String discussionID,
      {int attempt = 1}) async {
    final websocketClient = this.clientBloc.getWebsocketClient();

    if (websocketClient == null && attempt <= MAX_ATTEMPTS) {
      return Future.delayed(Duration(seconds: BACKOFF * attempt), () {
        return subscribe(discussionID, attempt: attempt + 1);
      });
    } else if (websocketClient == null) {
      throw Exception(
          "Failed to get discussion because backend connection is severed");
    }
    final subscription = DiscussionEventSubscription(discussionID);
    Stream<SubscriptionData> resStream = websocketClient.subscribe(
      SubscriptionRequest(Operation(
          operationName: "onDiscussionEvent",
          documentNode: gql(subscription.subscription()),
          variables: {
            'discussionID': discussionID,
          })),
      true,
    );

    return resStream.map<DiscussionSubscriptionEvent>((SubscriptionData res) {
      if (res.errors != null) {
        throw Exception("Caught errors from GQL subcription: ${res.errors}");
      }
      return subscription.parseResult(res.data);
    });
  }
}

@JsonAnnotation.JsonSerializable()
class Discussion extends Equatable implements Entity {
  final String id;
  final Moderator moderator;
  final AnonymityType anonymityType;
  final PostsConnection postsConnection;
  final List<Participant> participants;
  final String title;
  final String createdAt;
  final String updatedAt;
  final Participant meParticipant;
  final List<Participant> meAvailableParticipants;
  final String iconURL;
  final DiscussionAccessLink discussionAccessLink;
  final String description;
  final List<HistoricalString> titleHistory;
  final List<HistoricalString> descriptionHistory;
  final DiscussionJoinabilitySetting discussionJoinability;
  final CanJoinDiscussionResponse meCanJoinDiscussion;
  final Viewer meViewer;
  final DiscussionUserNotificationSetting meNotificationSetting;
  final List<DiscussionAccessRequest> accessRequests;

  @JsonAnnotation.JsonKey(ignore: true)
  final List<Post> postsCache;

  @JsonAnnotation.JsonKey(ignore: true)
  final bool isActivatedLocally;

  @JsonAnnotation.JsonKey(ignore: true)
  final bool isDeletedLocally;

  @JsonAnnotation.JsonKey(ignore: true)
  final bool isArchivedLocally;

  @override
  List<Object> get props => [
        id,
        moderator,
        anonymityType,
        postsConnection,
        participants,
        title,
        createdAt,
        updatedAt,
        meParticipant,
        meAvailableParticipants,
        iconURL,
        description,
        titleHistory,
        descriptionHistory,
        discussionJoinability,
        isDeletedLocally,
        isActivatedLocally,
        isArchivedLocally,
        meCanJoinDiscussion,
        meViewer?.id,
        meNotificationSetting,
        accessRequests,
      ];

  Discussion({
    this.id,
    this.moderator,
    this.anonymityType,
    this.postsConnection,
    this.participants,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.meParticipant,
    this.meAvailableParticipants,
    this.iconURL,
    this.discussionAccessLink,
    this.description,
    this.titleHistory,
    this.descriptionHistory,
    this.discussionJoinability,
    this.meCanJoinDiscussion,
    postsCache,
    this.isDeletedLocally = false,
    this.isActivatedLocally = false,
    this.isArchivedLocally = false,
    this.meViewer,
    this.meNotificationSetting,
    this.accessRequests,
  }) : this.postsCache =
            postsCache ?? (postsConnection?.asPostList() ?? List());

  factory Discussion.fromJson(Map<String, dynamic> json) {
    return _$DiscussionFromJson(json);
  }

  Map<String, dynamic> toJSON() {
    return _$DiscussionToJson(this);
  }

  void addLocalPost(LocalPost post) {
    this.postsCache.insert(0, post.post);
  }

  String getEmojiIcon() {
    // Emoji Icon is a weird internally defined "url" for an emoji.
    if (this.iconURL != null && this.iconURL.startsWith("emoji://")) {
      return iconURL.substring("emoji://".length);
    }
    return null;
  }

  bool replaceLocalPost(Post withPost, GlobalKey localPostKey) {
    final keyAsString = localPostKey.toString();
    for (int i = 0; i < this.postsCache.length; i++) {
      final post = this.postsCache[i];
      if ((post.isLocalPost ?? false) && post.id == keyAsString) {
        this.postsCache[i] = withPost;
        return true;
      }
    }
    return false;
  }

  Participant getParticipantForPostIdx(int idx) {
    if (idx < 0 || idx >= this.postsCache.length) {
      return null;
    }
    final post = this.postsCache[idx];
    var participant = this.participants.firstWhere(
        (participant) =>
            participant.participantID == post.participant.participantID,
        orElse: () => null);
    if (participant == null) {
      // Not sure what to do here.
    }
    return participant;
  }

  bool isMeDiscussionModerator() {
    return this
            .meAvailableParticipants
            ?.map((e) => e?.userProfile?.id)
            ?.contains(this.moderator?.userProfile?.id) ??
        false;
  }

  bool get isMuted {
    return this.meNotificationSetting != null &&
        this.meNotificationSetting !=
            DiscussionUserNotificationSetting.EVERYTHING;
  }

  bool get isPendingAccess {
    return this.meCanJoinDiscussion == null ||
        this.meCanJoinDiscussion.response ==
            DiscussionJoinabilityResponse.APPROVED_NOT_JOINED ||
        this.meCanJoinDiscussion.response ==
            DiscussionJoinabilityResponse.AWAITING_APPROVAL;
  }

  Discussion copyWith({
    String id,
    Moderator moderator,
    AnonymityType anonymityType,
    PostsConnection postsConnection,
    List<Participant> participants,
    String title,
    String createdAt,
    String updatedAt,
    Participant meParticipant,
    List<Participant> meAvailableParticipants,
    String iconURL,
    DiscussionAccessLink discussionAccessLink,
    String description,
    List<HistoricalString> titleHistory,
    List<HistoricalString> descriptionHistory,
    DiscussionJoinabilitySetting discussionJoinability,
    CanJoinDiscussionResponse meCanJoinDiscussion,
    List<Post> postsCache,
    bool isActivatedLocally,
    bool isDeletedLocally,
    bool isArchivedLocally,
    Viewer meViewer,
    DiscussionUserNotificationSetting meNotificationSetting,
    List<DiscussionAccessRequest> accessRequests,
  }) {
    return Discussion(
      id: id ?? this.id,
      moderator: moderator ?? this.moderator,
      anonymityType: anonymityType ?? this.anonymityType,
      postsConnection: postsConnection ?? this.postsConnection,
      participants: participants ?? this.participants,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      meParticipant: meParticipant ?? this.meParticipant,
      meAvailableParticipants:
          meAvailableParticipants ?? this.meAvailableParticipants,
      iconURL: iconURL ?? this.iconURL,
      discussionAccessLink: discussionAccessLink ?? this.discussionAccessLink,
      description: description ?? this.description,
      titleHistory: titleHistory ?? this.titleHistory,
      descriptionHistory: descriptionHistory ?? this.descriptionHistory,
      discussionJoinability:
          discussionJoinability ?? this.discussionJoinability,
      meCanJoinDiscussion: meCanJoinDiscussion ?? this.meCanJoinDiscussion,
      postsCache: postsCache ?? this.postsCache,
      isActivatedLocally: isActivatedLocally ?? this.isActivatedLocally,
      isDeletedLocally: isDeletedLocally ?? this.isDeletedLocally,
      isArchivedLocally: isArchivedLocally ?? this.isArchivedLocally,
      meViewer: meViewer ?? this.meViewer,
      meNotificationSetting:
          meNotificationSetting ?? this.meNotificationSetting,
      accessRequests: accessRequests ?? this.accessRequests,
    );
  }
}

@JsonAnnotation.JsonSerializable()
class DiscussionInput extends Equatable {
  final String title;
  final String description;
  final String iconURL;
  final AnonymityType anonymityType;
  final bool autoPost;
  final int idleMinutes;
  final bool publicAccess;
  final DiscussionJoinabilitySetting discussionJoinability;

  const DiscussionInput({
    this.title,
    this.description,
    this.iconURL,
    this.anonymityType,
    this.autoPost,
    this.idleMinutes,
    this.publicAccess,
    this.discussionJoinability,
  });

  @override
  List<Object> get props => [
        title,
        description,
        iconURL,
        anonymityType,
        autoPost,
        idleMinutes,
        publicAccess,
        discussionJoinability,
      ];

  factory DiscussionInput.fromJson(Map<String, dynamic> json) =>
      _$DiscussionInputFromJson(json);

  Map<String, dynamic> toJSON() {
    return _$DiscussionInputToJson(this);
  }
}

@JsonAnnotation.JsonSerializable()
class DiscussionAccessLink extends Equatable {
  final Discussion discussion;
  final String url;
  final String linkSlug;
  final String createdAt;
  final String updatedAt;
  final bool isDeleted;

  const DiscussionAccessLink({
    this.discussion,
    this.url,
    this.linkSlug,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
  });

  @override
  List<Object> get props => [
        this.discussion?.id,
        this.url,
        this.linkSlug,
        this.isDeleted,
      ];

  factory DiscussionAccessLink.fromJson(Map<String, dynamic> json) =>
      _$DiscussionAccessLinkFromJson(json);
}

@JsonAnnotation.JsonSerializable()
class CanJoinDiscussionResponse extends Equatable {
  final DiscussionJoinabilityResponse response;
  final String reason;
  final int reasonCode;

  CanJoinDiscussionResponse({
    this.response,
    this.reason,
    this.reasonCode,
  });

  @override
  List<Object> get props => [response, reason, reasonCode];

  CanJoinDiscussionResponse copyWith({
    DiscussionJoinabilityResponse response,
    String reason,
    int reasonCode,
  }) {
    return CanJoinDiscussionResponse(
      response: response ?? this.response,
      reason: reason ?? this.reason,
      reasonCode: reasonCode ?? this.reasonCode,
    );
  }

  factory CanJoinDiscussionResponse.fromJson(Map<String, dynamic> json) =>
      _$CanJoinDiscussionResponseFromJson(json);
}

@JsonAnnotation.JsonSerializable()
class ListDiscussionsResponse extends Equatable {
  final List<Discussion> activeDiscussions;
  final List<Discussion> archivedDiscussions;
  final List<Discussion> deletedDiscussions;

  @override
  List<Object> get props =>
      [activeDiscussions, archivedDiscussions, deletedDiscussions];

  const ListDiscussionsResponse({
    this.activeDiscussions,
    this.archivedDiscussions,
    this.deletedDiscussions,
  });

  ListDiscussionsResponse copyWith({
    List<Discussion> activeDiscussions,
    List<Discussion> archivedDiscussions,
    List<Discussion> deletedDiscussions,
  }) {
    return ListDiscussionsResponse(
      activeDiscussions: activeDiscussions ?? this.activeDiscussions,
      archivedDiscussions: archivedDiscussions ?? this.archivedDiscussions,
      deletedDiscussions: deletedDiscussions ?? this.deletedDiscussions,
    );
  }

  factory ListDiscussionsResponse.fromJson(Map<String, dynamic> json) =>
      _$ListDiscussionsResponseFromJson(json);
}

enum DiscussionJoinabilitySetting {
  ALLOW_TWITTER_FRIENDS,
  ALL_REQUIRE_APPROVAL
}

enum DiscussionJoinabilityResponse {
  ALREADY_JOINED,
  APPROVED_NOT_JOINED,
  AWAITING_APPROVAL,
  APPROVAL_REQUIRED,
  DENIED,
}
