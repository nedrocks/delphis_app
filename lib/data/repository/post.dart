import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'discussion.dart';
import 'participant.dart';

part 'post.g.dart';

enum PostDeletedReason { UNKNOWN, MODERATOR_REMOVED, PARTICIPANT_REMOVED }

@JsonSerializable()
class Post extends Equatable {
  final String id;
  final bool isDeleted;
  final PostDeletedReason deletedReasonCode;
  final String content;
  final Discussion discussion;
  final Participant participant;
  final String createdAt;
  final String updatedAt;

  final bool isLocalPost;

  List<Object> get props => [
        id,
        isDeleted,
        deletedReasonCode,
        content,
        discussion,
        participant,
        createdAt,
        updatedAt
      ];

  const Post({
    this.id,
    this.isDeleted = false,
    this.deletedReasonCode,
    this.content,
    this.discussion,
    this.participant,
    this.createdAt,
    this.updatedAt,
    this.isLocalPost = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  DateTime createdAtAsDateTime() {
    return DateTime.parse(this.createdAt);
  }
}

class LocalPost {
  bool isProcessing;
  bool isFailed;
  int failCount;
  final Post post;

  final GlobalKey key;

  LocalPost({
    @required this.isProcessing,
    @required this.isFailed,
    @required this.failCount,
    @required this.post,
    @required this.key,
  }) : super();
}
