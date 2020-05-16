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
      'gradientColor': instance.gradientColor,
      'flair': instance.flair,
      'hasJoined': instance.hasJoined,
    };
