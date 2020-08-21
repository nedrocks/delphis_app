import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:delphis_app/data/repository/twitter_user.dart';
import 'package:flutter/material.dart';

import '../repository/discussion.dart';
import '../repository/user.dart';

const InviterParticipantInfoFragment = """
  fragment InviterParticipantInfoFragment on Participant {
    id
  }
""";

const DiscussionUserAccessFragment = """
  fragment DiscussionUserAccessFragment on DiscussionUserAccess {
    discussion {
      id
      meNotificationSettings
    }
    user {
      id
    }
    state
    createdAt
    updatedAt
    isDeleted
    request {
      ...DiscussionAccessRequestFragment
    }
  }
  $DiscussionAccessRequestFragment
""";

const DiscussionAccessRequestFragment = """
  fragment DiscussionAccessRequestFragment on DiscussionAccessRequest {
    id
    discussion {
      id
    }
    userProfile {
      id
      displayName
      profileImageURL
    }
    createdAt
    updatedAt
    isDeleted
    status
  }
""";

const ViewerInfoFragment = """
  fragment ViewerInfoFragment on Viewer {
    id
    discussion {
      id
    }
    lastViewed
    lastViewedPost {
      id
      createdAt
    }
  }
""";

const ParticipantInfoFragment = """
  fragment ParticipantInfoFragment on Participant {
    id
    participantID
    isAnonymous
    isBanned
    gradientColor
    anonDisplayName
    hasJoined
    mutedForSeconds
    userProfile{
      ...ParticipantUserProfileFragment
    }
    inviter {
      ...InviterParticipantInfoFragment
    }
    discussion {
      id
    }
  }
  $ParticipantUserProfileFragment
  $InviterParticipantInfoFragment
""";

const QuotedPostInfoFragment = """
  fragment QuotedPostInfoFragment on Post {
    id
    content
    participant {
      id
      participantID
    }
    isDeleted
    createdAt
    updatedAt
    mentionedEntities {
      id
      ... on Discussion {
        title
        anonymityType
      }
      ... on Participant {
        isAnonymous
        participantID
      }
    }
    postType
  }
""";

const PostInfoFragment = """
  fragment PostInfoFragment on Post {
    id
    content
    participant {
      id
      participantID
    }
    isDeleted
    createdAt
    updatedAt
    deletedReasonCode
    mentionedEntities {
      id
      ... on Discussion {
        title
        anonymityType
      }
      ... on Participant {
        isAnonymous
        participantID
      }
    }
    quotedPost{
      ...QuotedPostInfoFragment
    }
    postType
    media {
      id
      createdAt
      isDeleted
      mediaType
      mediaSize {
        height
        width
        sizeKb
      }
      assetLocation
    }
  }
  $QuotedPostInfoFragment
""";

const PostWithParticipantInfoFragment = """
  fragment PostWithParticipantInfoFragment on Post {
    id
    content
    participant {
      ...ParticipantInfoFragment
    }
    isDeleted
    createdAt
    updatedAt
    deletedReasonCode
    mentionedEntities {
      id
      ... on Discussion {
        title
        anonymityType
      }
      ... on Participant {
        isAnonymous
        participantID
      }
    }
    quotedPost{
      ...QuotedPostInfoFragment
    }
    postType
    media {
      id
      createdAt
      isDeleted
      mediaType
      mediaSize {
        height
        width
        sizeKb
      }
      assetLocation
    }
  }
  $ParticipantInfoFragment
  $QuotedPostInfoFragment
""";

const DeletedPostInfoFragment = """
  fragment DeletedPostInfoFragment on Post {
    id
    participant {
      id
      participantID
    }
    isDeleted
    createdAt
    updatedAt
    postType
    deletedReasonCode
  }
""";

const PostsConnectionFragment = """
  fragment PostsConnectionFragment on PostsConnection {
    pageInfo {
      startCursor
      endCursor
      hasNextPage
    }
    edges {
      cursor
      node {
        ...PostInfoFragment
      }
    }
  }
  $PostInfoFragment
""";

const _userProfileFields = """
  id
  displayName
  twitterURL {
    displayText
    url
  }
  profileImageURL
""";

const UserProfileFragment = """
  fragment UserProfileFullFragment on UserProfile {
    $_userProfileFields
  }
""";

const ParticipantUserProfileFragment = """
  fragment ParticipantUserProfileFragment on UserProfile {
    $_userProfileFields
  }
""";

const DiscussionModeratorFragment = """
  fragment DiscussionModeratorFragment on Moderator {
    id
    userProfile {
      ...UserProfileFullFragment
    }
  }
  $UserProfileFragment
""";

// Does not fetch specific information about the Discussion, only enough
// to show it in a list of discussions.
const DiscussionListFragment = """
  fragment DiscussionListFragment on Discussion {
    id
    title
    description
    createdAt
    updatedAt
    moderator {
      ...DiscussionModeratorFragment
    }
    meAvailableParticipants {
      ...ParticipantInfoFragment
    }
    meParticipant {
      ...ParticipantInfoFragment
    }
    participants {
      ...ParticipantInfoFragment
    }
    meCanJoinDiscussion {
      response
      reason
      reasonCode
    }
    meViewer {
      ...ViewerInfoFragment
    }
    anonymityType
    iconURL
    discussionJoinability
    meNotificationSettings
    meDiscussionStatus
    lockStatus
  }
  $DiscussionModeratorFragment
  $ParticipantInfoFragment
  $ViewerInfoFragment
""";

const DiscussionFragmentFull = """
  fragment DiscussionFragmentFull on Discussion {
    ...DiscussionListFragment
    postsConnection {
      ...PostsConnectionFragment
    }
    titleHistory {
      value
      createdAt
    }
    descriptionHistory {
      value
      createdAt
    }
    secondsUntilShuffle
  }
  $DiscussionListFragment
  $PostsConnectionFragment
""";

const DiscussionAccessLinkFragment = """
  fragment DiscussionAccessLinkFragment on DiscussionAccessLink {
    discussion {
      id
    }
    url
    linkSlug
    createdAt
    updatedAt
    isDeleted
  }
""";

const TwitterUserInfoFragment = """
  fragment TwitterUserInfoFragment on TwitterUserInfo {
    id
    verified
    name
    displayName
    profileImageURL
  	invited
  }
""";

const DiscussionInviteFragment = """
  fragment DiscussionInviteFragment on DiscussionInvite {
    id
    discussion {
      ...DiscussionListFragment
    }
    invitingParticipant {
      ...ParticipantInfoFragment
    }
    createdAt
    updatedAt
    isDeleted
    status
  }
  $DiscussionListFragment
""";

abstract class GQLQuery<T> {
  T parseResult(dynamic data);
  String query();

  const GQLQuery();
}

class MeGQLQuery extends GQLQuery<User> {
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

  const MeGQLQuery() : super();

  String query() {
    return this._query;
  }

  User parseResult(dynamic data) {
    return User.fromJson(data["me"]);
  }
}

class PostsConnectionForDiscussionQuery extends GQLQuery<PostsConnection> {
  final String discussionID;
  final String after;
  final String _query = """
    query Discussion(\$id: ID!, \$after: ID) {
      discussion(id: \$id) {
        postsConnection(after: \$after) {
          ...PostsConnectionFragment
        }
      }
    }
    $PostsConnectionFragment
  """;

  const PostsConnectionForDiscussionQuery({
    @required this.discussionID,
    this.after,
  }) : super();

  String query() {
    return this._query;
  }

  PostsConnection parseResult(dynamic data) {
    return PostsConnection.fromJson(data['discussion']['postsConnection']);
  }
}

class ParticipantsForDiscussionQuery extends GQLQuery<List<Participant>> {
  final String discussionID;
  final String _query = """
    query Discussion(\$id: ID!) {
      participants {
        ...ParticipantInfoFragment
      }
    }
    $ParticipantInfoFragment
  """;

  const ParticipantsForDiscussionQuery({
    @required this.discussionID,
  }) : super();

  String query() {
    return this._query;
  }

  List<Participant> parseResult(dynamic data) {
    var participants = data['discussion']['participants'] as List<dynamic>;
    return participants.map<Participant>((dynamic serPar) {
      return Participant.fromJson(serPar);
    });
  }
}

class SingleDiscussionGQLQuery extends GQLQuery<Discussion> {
  final String discussionID;
  final String _query = """
    query Discussion(\$id: ID!) {
      discussion(id: \$id){
        ...DiscussionFragmentFull
      }
    }
    $DiscussionFragmentFull
  """;

  const SingleDiscussionGQLQuery({
    this.discussionID,
  }) : super();

  String query() {
    return this._query;
  }

  Discussion parseResult(dynamic data) {
    return Discussion.fromJson(data["discussion"]);
  }
}

class DiscussionFromDiscussionSlugQuery extends GQLQuery<Discussion> {
  final String slug;
  final String _query = """
    query DiscussionByLinkSlug(\$slug: String!) {
      discussionByLinkSlug(slug: \$slug){
        ...DiscussionFragmentFull
      }
    }
    $DiscussionFragmentFull
  """;

  const DiscussionFromDiscussionSlugQuery({
    this.slug,
  });

  String query() {
    return this._query;
  }

  Discussion parseResult(dynamic data) {
    return Discussion.fromJson(data["discussionByLinkSlug"]);
  }
}

class DiscussionModOnlyFieldsGQLQuery extends GQLQuery<Discussion> {
  final String discussionID;
  final String _query = """
    query DiscussionModOnlyFields(\$id: ID!) {
      discussion(id: \$id){
        discussionAccessLink {
          ...DiscussionAccessLinkFragment
        }
        accessRequests {
          ...DiscussionAccessRequestFragment
        }
      }
    }
    $DiscussionAccessRequestFragment
    $DiscussionAccessLinkFragment
  """;

  const DiscussionModOnlyFieldsGQLQuery({
    this.discussionID,
  }) : super();

  String query() {
    return this._query;
  }

  Discussion parseResult(dynamic data) {
    return Discussion.fromJson(data["discussion"]);
  }
}

class ListDiscussionsGQLQuery extends GQLQuery<ListDiscussionsResponse> {
  final String _query = """
    query Discussions () {
      activeDiscussions: listDiscussions (state: ACTIVE) {
        ...DiscussionListFragment
      }
      archivedDiscussions: listDiscussions (state: ARCHIVED) {
        ...DiscussionListFragment
      }
      deletedDiscussions: listDiscussions (state: DELETED) {
        ...DiscussionListFragment
      }
    }
    $DiscussionListFragment
  """;

  const ListDiscussionsGQLQuery() : super();

  String query() {
    return this._query;
  }

  ListDiscussionsResponse parseResult(dynamic data) {
    return ListDiscussionsResponse.fromJson(data);
  }
}

class ListMyDiscussionsGQLQuery extends GQLQuery<List<Discussion>> {
  final String _query = """
    query MyDiscussions() {
      me {
        discussions {
          ...DiscussionListFragment
        }
      }
    }
    $DiscussionListFragment
  """;

  const ListMyDiscussionsGQLQuery() : super();

  String query() {
    return this._query;
  }

  List<Discussion> parseResult(dynamic data) {
    return User.fromJson(data["me"]).discussions;
  }
}

class TwitterUserAutocompletesQuery extends GQLQuery<List<TwitterUserInfo>> {
  final String queryParam;
  final String discussionID;
  final String invitingParticipantID;
  final String _internalQuery = """
    query TwitterUserAutocompletes(\$query: ID!, \$discussionID: ID!, \$invitingParticipantID: ID!) {
      twitterUserAutocompletes(query: \$query, discussionID: \$discussionID, invitingParticipantID: \$invitingParticipantID) {
        ...TwitterUserInfoFragment
      }
    }
    $TwitterUserInfoFragment
  """;

  const TwitterUserAutocompletesQuery(
      {@required this.queryParam,
      @required this.discussionID,
      @required this.invitingParticipantID})
      : super();

  String query() {
    return this._internalQuery;
  }

  List<TwitterUserInfo> parseResult(dynamic data) {
    if (data["twitterUserAutocompletes"] == null) return [];
    return (data["twitterUserAutocompletes"] as List<dynamic>)
        .map((elem) => TwitterUserInfo.fromJson(elem))
        .toList();
  }
}
