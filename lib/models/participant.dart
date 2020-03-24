import 'package:json_annotation/json_annotation.dart';

import 'discussion.dart';
import 'post.dart';
import 'viewer.dart';

part 'participant.g.dart';

@JsonSerializable()
class Participant {
  final int participantId;
  final Discussion discussion;
  final Viewer viewer;
  final List<Post> posts;

  const Participant({
    this.participantId,
    this.discussion,
    this.viewer,
    this.posts,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => _$ParticipantFromJson(json);
}