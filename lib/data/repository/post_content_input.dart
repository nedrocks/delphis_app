import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_content_input.g.dart';

enum PostType { TEXT, MEDIA, POLL }

@JsonSerializable()
class PostContentInput extends Equatable {
  final String postText;
  final PostType postType;
  final List<String> mentionedUserIDs;
  final String quotedPostID;

  List<Object> get props => [
        this.postText,
        this.postType,
        this.mentionedUserIDs,
        this.quotedPostID,
      ];

  const PostContentInput({
    @required this.postText,
    @required this.postType,
    this.mentionedUserIDs,
    this.quotedPostID,
  });

  Map<String, dynamic> toJSON() {
    return _$PostContentInputToJson(this);
  }
}
