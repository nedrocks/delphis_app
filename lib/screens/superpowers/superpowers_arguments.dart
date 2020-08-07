import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';

class SuperpowersArguments {
  final Post post;
  final Discussion discussion;
  final Participant participant;

  SuperpowersArguments({
    this.post,
    this.discussion,
    this.participant,
  });

  SuperpowersArguments copyWith({
    Post post,
    Discussion discussion,
    Participant participant,
  }) {
    return SuperpowersArguments(
      post: post ?? this.post,
      discussion: discussion ?? this.discussion,
      participant: participant ?? this.participant,
    );
  }
}
