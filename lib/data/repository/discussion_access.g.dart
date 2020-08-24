// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discussion_access.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscussionAccessRequest _$DiscussionAccessRequestFromJson(
    Map<String, dynamic> json) {
  return DiscussionAccessRequest(
    id: json['id'] as String,
    userProfile: json['userProfile'] == null
        ? null
        : UserProfile.fromJson(json['userProfile'] as Map<String, dynamic>),
    discussion: json['discussion'] == null
        ? null
        : Discussion.fromJson(json['discussion'] as Map<String, dynamic>),
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
    isDeleted: json['isDeleted'] as bool,
    status: _$enumDecodeNullable(_$InviteRequestStatusEnumMap, json['status']),
  );
}

Map<String, dynamic> _$DiscussionAccessRequestToJson(
        DiscussionAccessRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userProfile': instance.userProfile,
      'discussion': instance.discussion,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
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

DiscussionUserAccess _$DiscussionUserAccessFromJson(Map<String, dynamic> json) {
  return DiscussionUserAccess(
    discussion: json['discussion'] == null
        ? null
        : Discussion.fromJson(json['discussion'] as Map<String, dynamic>),
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    state:
        _$enumDecodeNullable(_$DiscussionUserAccessStateEnumMap, json['state']),
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
    isDeleted: json['isDeleted'] as bool,
    request: json['request'] == null
        ? null
        : DiscussionAccessRequest.fromJson(
            json['request'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DiscussionUserAccessToJson(
        DiscussionUserAccess instance) =>
    <String, dynamic>{
      'discussion': instance.discussion,
      'user': instance.user,
      'state': _$DiscussionUserAccessStateEnumMap[instance.state],
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isDeleted': instance.isDeleted,
      'request': instance.request,
    };

const _$DiscussionUserAccessStateEnumMap = {
  DiscussionUserAccessState.ACTIVE: 'ACTIVE',
  DiscussionUserAccessState.ARCHIVED: 'ARCHIVED',
  DiscussionUserAccessState.DELETED: 'DELETED',
  DiscussionUserAccessState.BANNED: 'BANNED',
};
