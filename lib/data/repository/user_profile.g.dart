// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return UserProfile(
    id: json['id'] as String,
    displayName: json['displayName'] as String,
    moderatedDiscussions: (json['moderatedDiscussions'] as List)
        ?.map((e) =>
            e == null ? null : Discussion.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    twitterURL: json['twitterURL'] == null
        ? null
        : URL.fromJson(json['twitterURL'] as Map<String, dynamic>),
    profileImageURL: json['profileImageURL'] as String,
  );
}

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'moderatedDiscussions': instance.moderatedDiscussions,
      'twitterURL': instance.twitterURL,
      'profileImageURL': instance.profileImageURL,
    };
