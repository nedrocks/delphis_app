import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart' as JsonAnnotation;

part 'discussion.g.dart';

@JsonAnnotation.JsonSerializable()
class DiscussionArguments {
  final String discussionID;
  final bool isStartJoinFlow;

  const DiscussionArguments({
    @required this.discussionID,
    this.isStartJoinFlow = false,
  });

  factory DiscussionArguments.fromJsonString(String input) =>
      DiscussionArguments.fromJson(json.decode(input));

  factory DiscussionArguments.fromJson(Map<String, dynamic> input) =>
      _$DiscussionArgumentsFromJson(input);

  Map<String, dynamic> toJson() => _$DiscussionArgumentsToJson(this);

  String toJsonString() => json.encode(this.toJson());
}
