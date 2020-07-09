import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:flutter/material.dart';

import '../repository/discussion.dart';
import '../repository/user.dart';

const InviterParticipantInfoFragment = """
  fragment InviterParticipantInfoFragment on Participant {
    id
    participantID
    isAnonymous
    gradientColor
    flair {
      id
      displayName
      imageURL
      source
    }
    hasJoined
    userProfile{
      ...ParticipantUserProfileFragment
    }
  }
  $ParticipantUserProfileFragment
""";

const ParticipantInfoFragment = """
  fragment ParticipantInfoFragment on Participant {
    id
    participantID
    isAnonymous
    gradientColor
    flair {
      id
      displayName
      imageURL
      source
    }
    hasJoined
    userProfile{
      ...ParticipantUserProfileFragment
    }
    inviter{
      ...InviterParticipantInfoFragment
    }
  }
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
    conciergeContent{
      appActionID
      mutationID
      options{
        text
        value
        selected
      }
    }
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
    conciergeContent{
      appActionID
      mutationID
      options{
        text
        value
        selected
      }
    }
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
    anonymityType
    iconURL
  }
  $DiscussionModeratorFragment
  $ParticipantInfoFragment
""";

const DiscussionFragmentFull = """
  fragment DiscussionFragmentFull on Discussion {
    ...DiscussionListFragment
    postsConnection {
      ...PostsConnectionFragment
    }
  }
  $DiscussionListFragment
  $PostsConnectionFragment
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
        flairs{
          id
          displayName
          imageURL
          source
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

class ListDiscussionsGQLQuery extends GQLQuery<List<Discussion>> {
  final String _query = """
    query Discussions() {
      listDiscussions {
        ...DiscussionListFragment
      }
    }
    $DiscussionListFragment
  """;

  const ListDiscussionsGQLQuery() : super();

  String query() {
    return this._query;
  }

  List<Discussion> parseResult(dynamic data) {
    return (data["listDiscussions"] as List<dynamic>)
        .map((elem) => Discussion.fromJson(elem))
        .toList();
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
