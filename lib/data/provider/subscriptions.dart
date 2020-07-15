import 'package:delphis_app/data/provider/queries.dart';
import 'package:delphis_app/data/repository/discussion_subscription.dart';

abstract class GQLSubscription<T> {
  T parseResult(dynamic data);
  String subscription();

  const GQLSubscription();
}

class DiscussionEventSubscription extends GQLSubscription<DiscussionSubscriptionEvent> {
  final String discussionID;
  final String _subscription = """
    subscription onDiscussionEvent(\$discussionID: String!) {
      onDiscussionEvent(discussionID: \$discussionID) {
        eventType
        entity {
          id
          ... on Post {
            ...PostWithParticipantInfoFragment
          }
          ... on Participant {
            ...ParticipantInfoFragment
          }
        }
      }
    }
    $PostWithParticipantInfoFragment
  """;

  const DiscussionEventSubscription(this.discussionID) : super();

  String subscription() {
    return this._subscription;
  }

  DiscussionSubscriptionEvent parseResult(dynamic data) {
    return DiscussionSubscriptionEvent.fromJson(data["onDiscussionEvent"]);
  }
}