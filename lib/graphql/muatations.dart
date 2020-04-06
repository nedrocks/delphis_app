import 'package:delphis_app/models/discussion.dart';
import 'package:delphis_app/models/post.dart';

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
    this.discussionID,
    this.postContent,
  });

  String mutation() {
    return this._mutation;
  }

  Post parseResult(dynamic data) {
    return Post.fromJson(data["addPost"]);
  }
}