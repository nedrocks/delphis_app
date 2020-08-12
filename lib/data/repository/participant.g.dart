// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Participant _$ParticipantFromJson(Map<String, dynamic> json) {
  return Participant(
    id: json['id'] as String,
    participantID: json['participantID'] as int,
    discussion: json['discussion'] == null
        ? null
        : Discussion.fromJson(json['discussion'] as Map<String, dynamic>),
    viewer: json['viewer'] == null
        ? null
        : Viewer.fromJson(json['viewer'] as Map<String, dynamic>),
    posts: (json['posts'] as List)
        ?.map(
            (e) => e == null ? null : Post.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    isAnonymous: json['isAnonymous'] as bool,
    gradientColor: json['gradientColor'] as String,
    flair: json['flair'] == null
        ? null
        : Flair.fromJson(json['flair'] as Map<String, dynamic>),
    hasJoined: json['hasJoined'] as bool,
    userProfile: json['userProfile'] == null
        ? null
        : UserProfile.fromJson(json['userProfile'] as Map<String, dynamic>),
    inviter: json['inviter'] == null
        ? null
        : Participant.fromJson(json['inviter'] as Map<String, dynamic>),
    isBanned: json['isBanned'] as bool,
    anonDisplayName: json['anonDisplayName'] as String,
    mutedUntil: json['mutedUntil'] == null
        ? null
        : DateTime.parse(json['mutedUntil'] as String),
  );
}

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participantID': instance.participantID,
      'discussion': instance.discussion,
      'viewer': instance.viewer,
      'posts': instance.posts,
      'isAnonymous': instance.isAnonymous,
      'isBanned': instance.isBanned,
      'gradientColor': instance.gradientColor,
      'flair': instance.flair,
      'hasJoined': instance.hasJoined,
      'userProfile': instance.userProfile,
      'inviter': instance.inviter,
      'mutedUntil': instance.mutedUntil?.toIso8601String(),
      'anonDisplayName': instance.anonDisplayName,
    };
