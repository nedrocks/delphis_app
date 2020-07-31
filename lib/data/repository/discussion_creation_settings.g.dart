// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discussion_creation_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscussionCreationSettings _$DiscussionCreationSettingsFromJson(
    Map<String, dynamic> json) {
  return DiscussionCreationSettings(
    discussionJoinability: _$enumDecodeNullable(
        _$DiscussionJoinabilitySettingEnumMap, json['discussionJoinability']),
  );
}

Map<String, dynamic> _$DiscussionCreationSettingsToJson(
        DiscussionCreationSettings instance) =>
    <String, dynamic>{
      'discussionJoinability':
          _$DiscussionJoinabilitySettingEnumMap[instance.discussionJoinability],
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

const _$DiscussionJoinabilitySettingEnumMap = {
  DiscussionJoinabilitySetting.ALLOW_TWITTER_FRIENDS: 'ALLOW_TWITTER_FRIENDS',
  DiscussionJoinabilitySetting.ALL_REQUIRE_APPROVAL: 'ALL_REQUIRE_APPROVAL',
};
