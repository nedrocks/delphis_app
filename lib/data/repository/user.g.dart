// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as String,
    participants: (json['participants'] as List)
        ?.map((e) =>
            e == null ? null : Participant.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    viewers: (json['viewers'] as List)
        ?.map((e) =>
            e == null ? null : Viewer.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    profile: json['profile'] == null
        ? null
        : UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
    flairs: (json['flairs'] as List)
        ?.map(
            (e) => e == null ? null : Flair.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'participants': instance.participants,
      'viewers': instance.viewers,
      'profile': instance.profile,
      'flairs': instance.flairs,
    };
