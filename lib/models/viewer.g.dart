// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'viewer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Viewer _$ViewerFromJson(Map<String, dynamic> json) {
  return Viewer(
    id: json['id'] as String,
    discussion: json['discussion'] == null
        ? null
        : Discussion.fromJson(json['discussion'] as Map<String, dynamic>),
    lastViewed: json['lastViewed'] == null
        ? null
        : DateTime.parse(json['lastViewed'] as String),
    lastViewedPost: json['lastViewedPost'] == null
        ? null
        : Post.fromJson(json['lastViewedPost'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ViewerToJson(Viewer instance) => <String, dynamic>{
      'id': instance.id,
      'discussion': instance.discussion,
      'lastViewed': instance.lastViewed?.toIso8601String(),
      'lastViewedPost': instance.lastViewedPost,
    };
