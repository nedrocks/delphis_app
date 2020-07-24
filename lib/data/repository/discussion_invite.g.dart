// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discussion_invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscussionInvite _$DiscussionInviteFromJson(Map<String, dynamic> json) {
  return DiscussionInvite(
    id: json['id'] as String,
    discussion: json['discussion'] == null
        ? null
        : Discussion.fromJson(json['discussion'] as Map<String, dynamic>),
    invitingParticipant: json['invitingParticipant'] == null
        ? null
        : Participant.fromJson(
            json['invitingParticipant'] as Map<String, dynamic>),
    createdAt: json['createdAt'] as String,
    updateAt: json['updateAt'] as String,
    isDeleted: json['isDeleted'] as bool,
    status: _$enumDecodeNullable(_$InviteRequestStatusEnumMap, json['status']),
  );
}

Map<String, dynamic> _$DiscussionInviteToJson(DiscussionInvite instance) =>
    <String, dynamic>{
      'id': instance.id,
      'discussion': instance.discussion,
      'invitingParticipant': instance.invitingParticipant,
      'createdAt': instance.createdAt,
      'updateAt': instance.updateAt,
      'isDeleted': instance.isDeleted,
      'status': _$InviteRequestStatusEnumMap[instance.status],
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

const _$InviteRequestStatusEnumMap = {
  InviteRequestStatus.ACCEPTED: 'ACCEPTED',
  InviteRequestStatus.REJECTED: 'REJECTED',
  InviteRequestStatus.PENDING: 'PENDING',
  InviteRequestStatus.CANCELLED: 'CANCELLED',
};
