import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:delphis_app/data/repository/media.dart';
import 'package:delphis_app/data/repository/post_content_input.dart';

import 'concierge_content.dart';
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
  final Post quotedPost;
  final PostType postType;
  final ConciergeContent conciergeContent;
  final Media media;
  final bool isLocalPost;

  @JsonKey(ignore: true)
  final File localMediaFile;
  @JsonKey(ignore: true)
  final MediaContentType localMediaContentType;

  List<Object> get props => [
        id,
        isDeleted,
        deletedReasonCode,
        content,
        discussion?.id,
        participant?.id,
        createdAt,
        updatedAt,
        mentionedEntities,
        media,
        localMediaFile,
        localMediaContentType
      ];

  const Post(
      {this.id,
      this.isDeleted = false,
      this.deletedReasonCode,
      this.content,
      this.discussion,
      this.participant,
      this.createdAt,
      this.updatedAt,
      this.mentionedEntities,
      this.isLocalPost = false,
      this.quotedPost,
      this.postType,
      this.conciergeContent,
      this.media,
      this.localMediaFile,
      this.localMediaContentType});

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Post copyWith(
      {id,
      isDeleted,
      deletedReasonCode,
      content,
      discussion,
      participant,
      createdAt,
      updatedAt,
      mentionedEntities,
      isLocalPost,
      quotedPost,
      postType,
      conciergeContent,
      media,
      localMediaFile,
      localMediaContentType}) {
    return Post(
        id: id ?? this.id,
        isDeleted: isDeleted ?? this.isDeleted,
        deletedReasonCode: deletedReasonCode ?? this.deletedReasonCode,
        content: content ?? this.content,
        discussion: discussion ?? this.discussion,
        participant: participant ?? this.participant,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        mentionedEntities: mentionedEntities ?? this.mentionedEntities,
        isLocalPost: isLocalPost ?? this.isLocalPost,
        quotedPost: quotedPost ?? this.quotedPost,
        postType: postType ?? this.postType,
        conciergeContent: conciergeContent ?? this.conciergeContent,
        media: media ?? this.media,
        localMediaFile: localMediaFile ?? this.localMediaFile,
        localMediaContentType:
            localMediaContentType ?? this.localMediaContentType);
  }

  DateTime createdAtAsDateTime() {
    if (this.isLocalPost ?? false) {
      return DateTime.now();
    }
    return DateTime.parse(this.createdAt);
  }
}

class LocalPost extends Equatable {
  final Post post;
  final bool isProcessing;
  final dynamic error;

  const LocalPost({
    @required this.post,
    @required this.isProcessing,
    this.error,
  });

  List<Object> get props => [post, isProcessing, error];

  LocalPost copyWith({
    Post post,
    dynamic error,
    bool isProcessing,
  }) {
    return LocalPost(
      post: post ?? this.post,
      isProcessing: isProcessing ?? this.isProcessing,
      error: error,
    );
  }
}

@JsonSerializable()
class PostsEdge extends Equatable {
  final String cursor;
  final Post node;

  PostsEdge({this.cursor, this.node});

  List<Object> get props => [cursor, node];

  factory PostsEdge.fromJson(Map<String, dynamic> json) =>
      _$PostsEdgeFromJson(json);
}

@JsonSerializable()
class PostsConnection extends Equatable {
  final List<PostsEdge> edges;
  final PageInfo pageInfo;

  PostsConnection({this.edges, this.pageInfo});

  List<Object> get props => [edges, pageInfo];

  factory PostsConnection.fromJson(Map<String, dynamic> json) =>
      _$PostsConnectionFromJson(json);

  List<Post> asPostList() {
    return edges.map((e) => e.node).toList();
  }
}
