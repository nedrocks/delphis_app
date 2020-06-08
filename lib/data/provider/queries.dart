import 'package:delphis_app/data/repository/participant.dart';
import 'package:flutter/material.dart';

import '../repository/discussion.dart';
import '../repository/user.dart';

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
  }
""";

const UserProfileFragment = """
  fragment UserProfileFullFragment on UserProfile {
    id
    displayName
    twitterURL {
      displayText
      url
    }
    profileImageURL
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
    posts {
      id
      content
      participant {
        id
        participantID
      }
      isDeleted
      createdAt
      updatedAt
    }
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
    var discussion = Discussion.fromJson(data["discussion"]);
    return discussion.copyWith(
        posts: (discussion.posts ?? []).reversed.toList());
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
