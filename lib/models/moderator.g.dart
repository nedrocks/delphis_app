// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Moderator _$ModeratorFromJson(Map<String, dynamic> json) {
  return Moderator(
    id: json['id'] as String,
    discussion: json['discussion'] == null
        ? null
        : Discussion.fromJson(json['discussion'] as Map<String, dynamic>),
    userProfile: json['userProfile'] == null
        ? null
        : UserProfile.fromJson(json['userProfile'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ModeratorToJson(Moderator instance) => <String, dynamic>{
      'id': instance.id,
      'discussion': instance.discussion,
      'userProfile': instance.userProfile,
    };
