import 'package:delphis_app/data/repository/flair.dart';
import 'package:delphis_app/data/repository/participant.dart';
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
  final String postContent;

  final String _mutation = """
    mutation AddPost(\$discussionId: ID!, \$postContent: String!) {
      addPost(discussionID: \$discussionId, postContent: \$postContent) {
        id
        content
        participant {
          participantID
        }
        isDeleted
        createdAt
        updatedAt
      }
    }
  """;

  const AddPostGQLMutation({
    @required this.discussionID,
    @required this.postContent,
  });

  String mutation() {
    return this._mutation;
  }

  Post parseResult(dynamic data) {
    return Post.fromJson(data["addPost"]);
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

class UpdateParticipantGQLMutation extends GQLMutation<Participant> {
  final String participantID;
  final GradientName gradientName;
  final Flair flair;
  final bool isAnonymous;
  final bool isUnsetFlairID;
  final bool isUnsetGradient;

  final String _mutation = """
    mutation UpdateParticipant(\$participantID: ID!, \$updateInput: UpdateParticipantInput!) {
      updateParticipant(participantID: \$participantID, updateInput: \$updateInput) {
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
      }
    }
  """;

  const UpdateParticipantGQLMutation({
    @required this.participantID,
    this.gradientName,
    this.flair,
    this.isAnonymous,
    this.isUnsetFlairID,
    this.isUnsetGradient,
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
