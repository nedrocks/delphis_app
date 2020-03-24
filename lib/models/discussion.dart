import 'package:json_annotation/json_annotation.dart';

import 'moderator.dart';
import 'participant.dart';
import 'post.dart';

part 'discussion.g.dart';

enum AnonymityType {
  UNKNOWN,
  WEAK,
  STRONG
}

@JsonSerializable()
class Discussion {
  final String id;
  final Moderator moderator;
  final AnonymityType anonymityType;
  final List<Post> posts;
  final List<Participant> participants;
  final String title;
  final String createdAt;
  final String updatedAt;

  const Discussion({
    this.id,
    this.moderator,
    this.anonymityType,
    this.posts,
    this.participants,
    this.title,
    this.createdAt,
    this.updatedAt,
  });

  factory Discussion.fromJson(Map<String, dynamic> json) => _$DiscussionFromJson(json);
}