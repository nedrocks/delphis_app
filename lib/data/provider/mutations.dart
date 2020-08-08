import 'package:delphis_app/data/provider/queries.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/discussion_access.dart';
import 'package:delphis_app/data/repository/discussion_creation_settings.dart';
import 'package:delphis_app/data/repository/discussion_invite.dart';
import 'package:delphis_app/data/repository/flair.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post_content_input.dart';
import 'package:delphis_app/data/repository/twitter_user.dart';
import 'package:delphis_app/data/repository/user_device.dart';
import 'package:delphis_app/data/repository/viewer.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:flutter/material.dart';

import '../repository/post.dart';

abstract class GQLMutation<T> {
  T parseResult(dynamic data);
  String mutation();

  const GQLMutation();
}

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

class SetLastPostViewedMutation extends GQLMutation<Viewer> {
  final String viewerID;
  final String postID;

  final String _mutation = """
    mutation setLastPostViewed(\$viewerID: ID!, \$postID: ID!) {
      setLastPostViewed(viewerID: \$viewerID, postID: \$postID) {
        ...ViewerInfoFragment
      }
    }
    $ViewerInfoFragment
  """;

  const SetLastPostViewedMutation({
    @required this.viewerID,
    @required this.postID,
  });

  String mutation() {
    return this._mutation;
  }

  Viewer parseResult(dynamic data) {
    return Viewer.fromJson(data["setLastPostViewed"]);
  }
}

class JoinDiscussionWithVIPLinkMutation extends GQLMutation<Discussion> {
  final String discussionID;
  final String vipToken;

  final String _mutation = """
    mutation JoinDiscussionWithVIPToken(\$discussionID: ID!, \$vipToken: ID!) {
      joinDiscussionWithVIPToken(discussionID: \$discussionID, vipToken: \$vipToken) {
        ...DiscussionFragmentFull
      }
    }
    $DiscussionFragmentFull
  """;

  const JoinDiscussionWithVIPLinkMutation({
    @required this.discussionID,
    @required this.vipToken,
  });

  String mutation() {
    return this._mutation;
  }

  Discussion parseResult(dynamic data) {
    return Discussion.fromJson(data["joinDiscussionWithVIPToken"]);
  }
}

class UpdateDiscussionUserSettingsMutation
    extends GQLMutation<DiscussionUserAccess> {
  final String discussionID;
  final DiscussionUserAccessState state;
  final DiscussionUserNotificationSetting notifSetting;

  const UpdateDiscussionUserSettingsMutation({
    @required this.discussionID,
    this.state,
    this.notifSetting,
  });

  final String _mutation = """
    mutation UpdateDiscussionUserSettings(\$discussionID: ID!, \$settings: DiscussionUserSettings!) {
      updateDiscussionUserSettings(discussionID: \$discussionID, settings: \$settings) {
        ...DiscussionUserAccessFragment
      }
    }
    $DiscussionUserAccessFragment
  """;

  Map<String, dynamic> createInputObject() {
    final stateString = this.state?.toString()?.split('.');
    final notifString = this.notifSetting?.toString()?.split('.');
    return {
      'state': stateString == null ? null : stateString[1],
      'notifSetting': notifString == null ? null : notifString[1],
    };
  }

  String mutation() {
    return this._mutation;
  }

  DiscussionUserAccess parseResult(dynamic data) {
    return DiscussionUserAccess.fromJson(data['updateDiscussionUserSettings']);
  }
}

class CreateDiscussionGQLMutation extends GQLMutation<Discussion> {
  final String title;
  final String description;
  final AnonymityType anonymityType;
  final DiscussionCreationSettings creationSettings;

  const CreateDiscussionGQLMutation({
    @required this.title,
    @required this.description,
    @required this.anonymityType,
    @required this.creationSettings,
  });

  final String _mutation = """
    mutation CreateDiscussion(\$anonymityType: AnonymityType!, \$title: String!, \$description: String!, \$discussionSettings: DiscussionCreationSettings!) {
      createDiscussion(anonymityType: \$anonymityType, title: \$title, description: \$description, discussionSettings : \$discussionSettings) {
        ...DiscussionFragmentFull
        discussionAccessLink {
          ...DiscussionAccessLinkFragment
        }
      }
    }
    $DiscussionFragmentFull
    $DiscussionAccessLinkFragment
  """;

  Map<String, dynamic> createInputObject() {
    return this.creationSettings.toJSON();
  }

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
        ...ParticipantInfoFragment
      }
    }
    $ParticipantInfoFragment
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
  final DiscussionInput input;

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
    @required this.input,
  }) : super();

  Map<String, dynamic> createInputObject() {
    return input.toJSON();
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
        ...ParticipantInfoFragment
      }
    }
    $ParticipantInfoFragment
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

class DeletePostMutation extends GQLMutation<Post> {
  final String discussionID;
  final String postID;

  final String _mutation = """
    mutation DeletePost(\$discussionID: ID!, \$postID: ID!) {
      deletePost(discussionID: \$discussionID, postID: \$postID) {
        ...DeletedPostInfoFragment
      }
    }
    $DeletedPostInfoFragment
  """;

  const DeletePostMutation({
    @required this.discussionID,
    @required this.postID,
  }) : super();

  String mutation() {
    return this._mutation;
  }

  Post parseResult(dynamic data) {
    return Post.fromJson(data["deletePost"]);
  }
}

class BanParticipantMutation extends GQLMutation<Participant> {
  final String discussionID;
  final String participantID;

  final String _mutation = """
    mutation BanParticipant(\$discussionID: ID!, \$participantID: ID!) {
      banParticipant(discussionID: \$discussionID, participantID: \$participantID) {
        ...ParticipantInfoFragment
      }
    }
    $ParticipantInfoFragment
  """;

  const BanParticipantMutation({
    @required this.discussionID,
    @required this.participantID,
  }) : super();

  String mutation() {
    return this._mutation;
  }

  Participant parseResult(dynamic data) {
    return Participant.fromJson(data["banParticipant"]);
  }
}

class RequestDiscussionAccessMutation
    extends GQLMutation<DiscussionAccessRequest> {
  final String discussionID;

  final String _mutation = """
   mutation RequestAccessToDiscussion(\$discussionID: ID!) {
     requestAccessToDiscussion(discussionID: \$discussionID) {
       ...DiscussionAccessRequestFragment
     }
   }
   $DiscussionAccessRequestFragment
  """;

  const RequestDiscussionAccessMutation({
    @required this.discussionID,
  });

  String mutation() {
    return this._mutation;
  }

  DiscussionAccessRequest parseResult(dynamic data) {
    return DiscussionAccessRequest.fromJson(data["requestAccessToDiscussion"]);
  }
}

class InviteTwitterUsersToDiscussionMutation
    extends GQLMutation<List<DiscussionInvite>> {
  final String discussionID;
  final String invitingParticipantID;
  final List<TwitterUserInput> twitterUsers;

  final String _mutation = """
    mutation InviteTwitterUsersToDiscussion(\$discussionID: ID!, \$invitingParticipantID: ID!, \$twitterUsersInput: [TwitterUserInput!]) {
      inviteTwitterUsersToDiscussion(discussionID: \$discussionID, invitingParticipantID: \$invitingParticipantID, twitterUsers: \$twitterUsersInput) {
        ...DiscussionInviteFragment
      }
    }
    $DiscussionInviteFragment
  """;

  const InviteTwitterUsersToDiscussionMutation({
    @required this.discussionID,
    @required this.invitingParticipantID,
    @required this.twitterUsers,
  }) : super();

  String mutation() {
    return this._mutation;
  }

  List<DiscussionInvite> parseResult(dynamic data) {
    return (data["inviteTwitterUsersToDiscussion"] as List<dynamic>)
        .map((elem) => DiscussionInvite.fromJson(elem))
        .toList();
  }
}
