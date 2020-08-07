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
    discussionLinksAccess: json['discussionLinksAccess'] == null
        ? null
        : DiscussionLinkAccess.fromJson(
            json['discussionLinksAccess'] as Map<String, dynamic>),
    description: json['description'] as String,
    titleHistory: (json['titleHistory'] as List)
        ?.map((e) => e == null
            ? null
            : HistoricalString.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    descriptionHistory: (json['descriptionHistory'] as List)
        ?.map((e) => e == null
            ? null
            : HistoricalString.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    discussionJoinability: _$enumDecodeNullable(
        _$DiscussionJoinabilitySettingEnumMap, json['discussionJoinability']),
    mutedUntil: json['mutedUntil'] == null
        ? null
        : DateTime.parse(json['mutedUntil'] as String),
    meCanJoinDiscussion: json['meCanJoinDiscussion'] == null
        ? null
        : CanJoinDiscussionResponse.fromJson(
            json['meCanJoinDiscussion'] as Map<String, dynamic>),
    meViewer: json['meViewer'] == null
        ? null
        : Viewer.fromJson(json['meViewer'] as Map<String, dynamic>),
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
      'discussionLinksAccess': instance.discussionLinksAccess,
      'description': instance.description,
      'titleHistory': instance.titleHistory,
      'descriptionHistory': instance.descriptionHistory,
      'discussionJoinability':
          _$DiscussionJoinabilitySettingEnumMap[instance.discussionJoinability],
      'mutedUntil': instance.mutedUntil?.toIso8601String(),
      'meCanJoinDiscussion': instance.meCanJoinDiscussion,
      'meViewer': instance.meViewer,
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

const _$DiscussionJoinabilitySettingEnumMap = {
  DiscussionJoinabilitySetting.ALLOW_TWITTER_FRIENDS: 'ALLOW_TWITTER_FRIENDS',
  DiscussionJoinabilitySetting.ALL_REQUIRE_APPROVAL: 'ALL_REQUIRE_APPROVAL',
};

DiscussionLinkAccess _$DiscussionLinkAccessFromJson(Map<String, dynamic> json) {
  return DiscussionLinkAccess(
    discussionID: json['discussionID'] as String,
    inviteLinkURL: json['inviteLinkURL'] as String,
    vipInviteLinkURL: json['vipInviteLinkURL'] as String,
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
    isDeleted: json['isDeleted'] as bool,
  );
}

Map<String, dynamic> _$DiscussionLinkAccessToJson(
        DiscussionLinkAccess instance) =>
    <String, dynamic>{
      'discussionID': instance.discussionID,
      'inviteLinkURL': instance.inviteLinkURL,
      'vipInviteLinkURL': instance.vipInviteLinkURL,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isDeleted': instance.isDeleted,
    };

CanJoinDiscussionResponse _$CanJoinDiscussionResponseFromJson(
    Map<String, dynamic> json) {
  return CanJoinDiscussionResponse(
    response: _$enumDecodeNullable(
        _$DiscussionJoinabilityResponseEnumMap, json['response']),
    reason: json['reason'] as String,
    reasonCode: json['reasonCode'] as int,
  );
}

Map<String, dynamic> _$CanJoinDiscussionResponseToJson(
        CanJoinDiscussionResponse instance) =>
    <String, dynamic>{
      'response': _$DiscussionJoinabilityResponseEnumMap[instance.response],
      'reason': instance.reason,
      'reasonCode': instance.reasonCode,
    };

const _$DiscussionJoinabilityResponseEnumMap = {
  DiscussionJoinabilityResponse.ALREADY_JOINED: 'ALREADY_JOINED',
  DiscussionJoinabilityResponse.APPROVED_NOT_JOINED: 'APPROVED_NOT_JOINED',
  DiscussionJoinabilityResponse.AWAITING_APPROVAL: 'AWAITING_APPROVAL',
  DiscussionJoinabilityResponse.APPROVAL_REQUIRED: 'APPROVAL_REQUIRED',
  DiscussionJoinabilityResponse.DENIED: 'DENIED',
};
