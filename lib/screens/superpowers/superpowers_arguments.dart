import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';

class SuperpowersArguments {
  final Post post;
  final Discussion discussion;
  final Participant participant;
  final LocalPost localPost;

  SuperpowersArguments({
    this.post,
    this.discussion,
    this.participant,
    this.localPost,
  });

  SuperpowersArguments copyWith({
    Post post,
    Discussion discussion,
    Participant participant,
    LocalPost localPost,
  }) {
    return SuperpowersArguments(
      post: post ?? this.post,
      discussion: discussion ?? this.discussion,
      participant: participant ?? this.participant,
      localPost: localPost ?? this.localPost,
    );
  }
}
