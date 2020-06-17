import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_content_input.g.dart';

enum PostType { STANDARD, IMPORTED_CONTENT, ALERT }

@JsonSerializable()
class PostContentInput extends Equatable {
  final String postText;
  final PostType postType;
  final List<String> mentionedEntities;
  final String quotedPostID;
  final String mediaID;

  List<Object> get props => [
        this.postText,
        this.postType,
        this.mentionedEntities,
        this.quotedPostID,
        this.mediaID,
      ];

  const PostContentInput({
    @required this.postText,
    @required this.postType,
    this.mentionedEntities,
    this.quotedPostID,
    this.mediaID,
  });

  Map<String, dynamic> toJSON() {
    return _$PostContentInputToJson(this);
  }
}
