import 'package:delphis_app/data/provider/queries.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/flair.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post_content_input.dart';
import 'package:delphis_app/data/repository/user_device.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:flutter/material.dart';

import '../repository/post.dart';

abstract class GQLMutation<T> {
  T parseResult(dynamic data);
  String mutation();

  const GQLMutation();
}

// TODO: Use fragments.
class AddPostGQLMutation extends GQLMutation<Post> {
  final String discussionID;
  final String participantID;
  final PostContentInput postContent;

  final String _mutation = """
    mutation AddPost(\$discussionID: ID!, \$participantID: ID!, \$postContent: PostContentInput!) {
      addPost(discussionID: \$discussionID, participantID: \$participantID, postContent: \$postContent) {
        ...PostInfoFragment
      }
    }
    $PostInfoFragment
  """;

  const AddPostGQLMutation({
    @required this.discussionID,
    @required this.participantID,
    @required this.postContent,
  });

  String mutation() {
    return this._mutation;
  }

  Post parseResult(dynamic data) {
    return Post.fromJson(data["addPost"]);
  }
}

class CreateDiscussionGQLMutation extends GQLMutation<Discussion> {
  final String title;
  final AnonymityType anonymityType;

  const CreateDiscussionGQLMutation({
    @required this.title,
    @required this.anonymityType,
  });

  final String _mutation = """
    mutation CreateDiscussion(\$anonymityType: AnonymityType!, \$title: String!) {
      createDiscussion(anonymityType: \$anonymityType, title: \$title) {
        ...DiscussionFragmentFull
      }
    }
    $DiscussionFragmentFull
  """;

  String mutation() {
    return this._mutation;
  }

  Discussion parseResult(dynamic data) {
    return Discussion.fromJson(data['createDiscussion']);
  }
}

class AddDiscussionParticipantGQLMutation extends GQLMutation<Participant> {
  final String discussionID;
  final String userID;
  final String gradientColor;
  final String flairID;
  final bool isAnonymous;
  final bool hasJoined;

  const AddDiscussionParticipantGQLMutation({
    @required this.discussionID,
    @required this.userID,
    @required this.gradientColor,
    @required this.flairID,
    @required this.isAnonymous,
    this.hasJoined = false,
  });

  final String _mutation = """
    mutation AddDiscussionParticipant(\$discussionID: String!, \$userID: String!, \$discussionParticipantInput: AddDiscussionParticipantInput!) {
      addDiscussionParticipant(discussionID: \$discussionID, userID: \$userID, discussionParticipantInput: \$discussionParticipantInput) {
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
    }
  """;

  Map<String, dynamic> createInputObject() {
    return {
      'isAnonymous': this.isAnonymous,
      'gradientColor': this.gradientColor,
      'flairID': this.flairID,
      'hasJoined': this.hasJoined,
    };
  }

  String mutation() {
    return this._mutation;
  }

  Participant parseResult(dynamic data) {
    return Participant.fromJson(data["addDiscussionParticipant"]);
  }
}

class UpdateUserDeviceGQLMutation extends GQLMutation<UserDevice> {
  final String userID;
  final String token;
  final ChathamPlatform platform;
  final String deviceID;

  final String _mutation = """
    mutation UpsertUserDevice(\$userID: ID, \$platform: Platform!, \$deviceID: String!, \$token: String) {
      upsertUserDevice(userID: \$userID, platform: \$platform, deviceID: \$deviceID, token: \$token) {
        id
      }
    }
  """;

  const UpdateUserDeviceGQLMutation({
    @required this.deviceID,
    @required this.platform,
    this.userID,
    this.token,
  }) : super();

  String mutation() {
    return this._mutation;
  }

  UserDevice parseResult(dynamic data) {
    return UserDevice.fromJson(data["upsertUserDevice"]);
  }
}

class ConciergeOptionMutation extends GQLMutation<Post> {
  final String discussionID;
  final String mutationID;
  final List<String> selectedOptionIDs;

  final String _mutation = """
    mutation ConciergeMutation(\$discussionID: ID!, \$mutationID: ID!, \$selectedOptions: [String!]) {
      conciergeMutation(discussionID: \$discussionID, mutationID: \$mutationID, selectedOptions: \$selectedOptions) {
        ...PostInfoFragment
      }
    }
    $PostInfoFragment
  """;

  const ConciergeOptionMutation({
    @required this.discussionID,
    @required this.mutationID,
    @required this.selectedOptionIDs,
  }) : super();

  String mutation() {
    return this._mutation;
  }

  Post parseResult(dynamic data) {
    return Post.fromJson(data["conciergeMutation"]);
  }
}

class UpdateDiscussionMutation extends GQLMutation<Discussion> {
  final String discussionID;
  final String title;
  final String iconURL;

  final String _mutation = """
    mutation UpdateDiscussion(\$discussionID: ID!, \$input: DiscussionInput!) {
      updateDiscussion(discussionID: \$discussionID, input: \$input) {
        ...DiscussionFragmentFull
      }
    }
    $DiscussionFragmentFull
  """;

  const UpdateDiscussionMutation({
    @required this.discussionID,
    this.title,
    this.iconURL,
  }) : super();

  Map<String, dynamic> createInputObject() {
    return {
      'title': this.title,
      'iconURL': this.iconURL,
    };
  }

  String mutation() {
    return this._mutation;
  }

  Discussion parseResult(dynamic data) {
    return Discussion.fromJson(data["updateDiscussion"]);
  }
}

class UpdateParticipantGQLMutation extends GQLMutation<Participant> {
  final String participantID;
  final String discussionID;
  final GradientName gradientName;
  final Flair flair;
  final bool isAnonymous;
  final bool isUnsetFlairID;
  final bool isUnsetGradient;
  final bool hasJoined;

  final String _mutation = """
    mutation UpdateParticipant(\$discussionID: ID!, \$participantID: ID!, \$updateInput: UpdateParticipantInput!) {
      updateParticipant(discussionID: \$discussionID, participantID: \$participantID, updateInput: \$updateInput) {
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
    }
  """;

  const UpdateParticipantGQLMutation({
    @required this.participantID,
    @required this.discussionID,
    this.gradientName,
    this.flair,
    this.isAnonymous,
    this.isUnsetFlairID = false,
    this.isUnsetGradient = false,
    this.hasJoined = true,
  })  : assert(!isUnsetFlairID || flair == null,
            'Cannot unset flair ID and pass non-null flair'),
        assert(!isUnsetGradient || gradientName == null,
            'Cannot unset gradient andp ass non-null gradient'),
        super();

  Map<String, dynamic> createInputObject() {
    var inputObj = {
      'flairID': this.flair == null ? null : this.flair.id,
      'isAnonymous': this.isAnonymous,
      'isUnsetFlairID': this.isUnsetFlairID,
      'isUnsetGradient': this.isUnsetGradient,
      'gradientColor': null,
      'hasJoined': this.hasJoined,
    };

    if (this.gradientName != null) {
      inputObj['gradientColor'] = this.gradientName.toString().split('.')[1];
    }

    return inputObj;
  }

  String mutation() {
    return this._mutation;
  }

  Participant parseResult(dynamic data) {
    return Participant.fromJson(data["updateParticipant"]);
  }
}
