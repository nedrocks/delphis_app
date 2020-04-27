import 'package:delphis_app/data/repository/post.dart';

abstract class GQLSubscription<T> {
  T parseResult(dynamic data);
  String subscription();

  const GQLSubscription();
}

class PostAddedSubscription extends GQLSubscription<Post> {
  final String discussionID;
  final String _subscription = """
    subscription postAdded(\$discussionID: String!) {
      postAdded(discussionID: \$discussionID) {
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

  const PostAddedSubscription(this.discussionID) : super();

  String subscription() {
    return this._subscription;
  }

  Post parseResult(dynamic data) {
    return Post.fromJson(data["postAdded"]);
  }
}
