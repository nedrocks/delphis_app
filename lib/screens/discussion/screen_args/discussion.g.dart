// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discussion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscussionArguments _$DiscussionArgumentsFromJson(Map<String, dynamic> json) {
  return DiscussionArguments(
    discussionID: json['discussionID'] as String,
    isStartJoinFlow: json['isStartJoinFlow'] as bool,
  );
}

Map<String, dynamic> _$DiscussionArgumentsToJson(
        DiscussionArguments instance) =>
    <String, dynamic>{
      'discussionID': instance.discussionID,
      'isStartJoinFlow': instance.isStartJoinFlow,
    };
