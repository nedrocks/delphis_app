import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'discussion.dart';
import 'entity.dart';
import 'page_info.dart';
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
  final List<Entity> mentionedEntities;
  final bool isLocalPost;

  List<Object> get props => [
        id,
        isDeleted,
        deletedReasonCode,
        content,
        discussion?.id,
        participant?.id,
        createdAt,
        updatedAt,
        mentionedEntities
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
    this.mentionedEntities,
    this.isLocalPost = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  DateTime createdAtAsDateTime() {
    if (this.isLocalPost ?? false) {
      return DateTime.now();
    }
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

@JsonSerializable()
class PostsEdge extends Equatable {
  final String cursor;
  final Post node;

  PostsEdge({this.cursor, this.node});

  List<Object> get props => [
        cursor,
        node
      ];

  factory PostsEdge.fromJson(Map<String, dynamic> json) => _$PostsEdgeFromJson(json);

}

@JsonSerializable()
class PostsConnection extends Equatable {
  final List<PostsEdge> edges;
  final PageInfo pageInfo;

  PostsConnection({this.edges, this.pageInfo});

  List<Object> get props => [
        edges,
        pageInfo
      ];

  factory PostsConnection.fromJson(Map<String, dynamic> json) => _$PostsConnectionFromJson(json);
  
  List<Post> asPostList() {
    return edges.map((e) => e.node).toList();
  }

}