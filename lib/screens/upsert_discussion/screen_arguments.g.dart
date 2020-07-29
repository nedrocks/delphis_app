// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_arguments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpsertDiscussionArguments _$UpsertDiscussionArgumentsFromJson(
    Map<String, dynamic> json) {
  return UpsertDiscussionArguments(
    discussion: json['discussion'] == null
        ? null
        : Discussion.fromJson(json['discussion'] as Map<String, dynamic>),
    firstPage: _$enumDecodeNullable(
        _$UpsertDiscussionScreenPageEnumMap, json['initialPage']),
  );
}

Map<String, dynamic> _$UpsertDiscussionArgumentsToJson(
        UpsertDiscussionArguments instance) =>
    <String, dynamic>{
      'discussion': instance.discussion,
      'initialPage': _$UpsertDiscussionScreenPageEnumMap[instance.firstPage],
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

const _$UpsertDiscussionScreenPageEnumMap = {
  UpsertDiscussionScreenPage.TITLE_DESCRIPTION: 'TITLE_DESCRIPTION',
  UpsertDiscussionScreenPage.TWITTER_AUTH: 'TWITTER_AUTH',
  UpsertDiscussionScreenPage.INVITATION_MODE: 'INVITATION_MODE',
  UpsertDiscussionScreenPage.CONFIRMATION: 'CONFIRMATION',
};
