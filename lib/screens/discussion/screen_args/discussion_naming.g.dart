// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discussion_naming.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscussionNamingArguments _$DiscussionNamingArgumentsFromJson(
    Map<String, dynamic> json) {
  return DiscussionNamingArguments(
    title: json['title'] as String,
    discussionID: json['discussionID'] as String,
  );
}

Map<String, dynamic> _$DiscussionNamingArgumentsToJson(
        DiscussionNamingArguments instance) =>
    <String, dynamic>{
      'title': instance.title,
      'discussionID': instance.discussionID,
    };
