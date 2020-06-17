// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discussion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Discussion _$DiscussionFromJson(Map<String, dynamic> json) {
  return Discussion(
    id: json['id'] as String,
    moderator: json['moderator'] == null
        ? null
        : Moderator.fromJson(json['moderator'] as Map<String, dynamic>),
    anonymityType:
        _$enumDecodeNullable(_$AnonymityTypeEnumMap, json['anonymityType']),
    postsConnection: json['postsConnection'] == null
        ? null
        : PostsConnection.fromJson(
            json['postsConnection'] as Map<String, dynamic>),
    participants: (json['participants'] as List)
        ?.map((e) =>
            e == null ? null : Participant.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    title: json['title'] as String,
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
    meParticipant: json['meParticipant'] == null
        ? null
        : Participant.fromJson(json['meParticipant'] as Map<String, dynamic>),
    meAvailableParticipants: (json['meAvailableParticipants'] as List)
        ?.map((e) =>
            e == null ? null : Participant.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    iconURL: json['iconURL'] as String,
  );
}

Map<String, dynamic> _$DiscussionToJson(Discussion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'moderator': instance.moderator,
      'anonymityType': _$AnonymityTypeEnumMap[instance.anonymityType],
      'postsConnection': instance.postsConnection,
      'participants': instance.participants,
      'title': instance.title,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'meParticipant': instance.meParticipant,
      'meAvailableParticipants': instance.meAvailableParticipants,
      'iconURL': instance.iconURL,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$AnonymityTypeEnumMap = {
  AnonymityType.UNKNOWN: 'UNKNOWN',
  AnonymityType.WEAK: 'WEAK',
  AnonymityType.STRONG: 'STRONG',
};
