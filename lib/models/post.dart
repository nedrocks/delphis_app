import 'package:json_annotation/json_annotation.dart';

import 'discussion.dart';
import 'participant.dart';

part 'post.g.dart';

enum PostDeletedReason {
  UNKNOWN,
  MODERATOR_REMOVED,
  PARTICIPANT_REMOVED
}

@JsonSerializable()
class Post {
  final String id;
  final bool isDeleted;
  final PostDeletedReason deletedReasonCode;
  final String content;
  final Discussion discussion;
  final Participant participant;
  final String createdAt;
  final String updatedAt;

  const Post({
    this.id,
    this.isDeleted,
    this.deletedReasonCode,
    this.content,
    this.discussion,
    this.participant,
    this.createdAt,
    this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  DateTime createdAtAsDateTime() {
    return DateTime.parse(this.createdAt);
  }
}