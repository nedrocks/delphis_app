import 'dart:convert';

import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/screens/upsert_discussion/upsert_discussion_screen.dart';
import 'package:json_annotation/json_annotation.dart' as JsonAnnotation;

part 'screen_arguments.g.dart';

@JsonAnnotation.JsonSerializable()
class UpsertDiscussionArguments {
  final Discussion discussion;
  final UpsertDiscussionScreenPage firstPage;
  final bool isUpdateMode;

  const UpsertDiscussionArguments({
    this.discussion,
    this.firstPage = UpsertDiscussionScreenPage.TITLE_DESCRIPTION,
    this.isUpdateMode = false,
  });

  factory UpsertDiscussionArguments.fromJsonString(String input) =>
      UpsertDiscussionArguments.fromJson(json.decode(input));

  factory UpsertDiscussionArguments.fromJson(Map<String, dynamic> input) =>
      _$UpsertDiscussionArgumentsFromJson(input);

  Map<String, dynamic> toJson() => _$UpsertDiscussionArgumentsToJson(this);

  String toJsonString() => json.encode(this.toJson());
}
