// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitter_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwitterUserInfo _$TwitterUserInfoFromJson(Map<String, dynamic> json) {
  return TwitterUserInfo(
    id: json['id'] as String,
    name: json['name'] as String,
    displayName: json['displayName'] as String,
    profileImageURL: json['profileImageURL'] as String,
    verified: json['verified'] as bool,
    invited: json['invited'] as bool,
  );
}

Map<String, dynamic> _$TwitterUserInfoToJson(TwitterUserInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'displayName': instance.displayName,
      'profileImageURL': instance.profileImageURL,
      'verified': instance.verified,
      'invited': instance.invited,
    };

TwitterUserInput _$TwitterUserInputFromJson(Map<String, dynamic> json) {
  return TwitterUserInput(
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$TwitterUserInputToJson(TwitterUserInput instance) =>
    <String, dynamic>{
      'name': instance.name,
    };
