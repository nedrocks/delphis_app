import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart' as JsonAnnotation;

part 'discussion_naming.g.dart';

@JsonAnnotation.JsonSerializable()
class DiscussionNamingArguments {
  final String title;
  final String discussionID;

  const DiscussionNamingArguments({
    @required this.title,
    @required this.discussionID,
  });

  factory DiscussionNamingArguments.fromJsonString(String input) =>
      _$DiscussionNamingArgumentsFromJson(json.decode(input));

  factory DiscussionNamingArguments.fromJson(Map<String, dynamic> input) =>
      _$DiscussionNamingArgumentsFromJson(input);

  Map<String, dynamic> toJson() => _$DiscussionNamingArgumentsToJson(this);

  String toJsonString() => json.encode(this.toJson());
}
