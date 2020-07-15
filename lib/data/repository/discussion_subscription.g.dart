// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discussion_subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscussionSubscriptionEvent _$DiscussionSubscriptionEventFromJson(
    Map<String, dynamic> json) {
  return DiscussionSubscriptionEvent(
    eventType: _$enumDecodeNullable(
        _$DiscussionSubscriptionEventTypeEnumMap, json['eventType']),
  );
}

Map<String, dynamic> _$DiscussionSubscriptionEventToJson(
        DiscussionSubscriptionEvent instance) =>
    <String, dynamic>{
      'eventType': _$DiscussionSubscriptionEventTypeEnumMap[instance.eventType],
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

const _$DiscussionSubscriptionEventTypeEnumMap = {
  DiscussionSubscriptionEventType.POST_ADDED: 'POST_ADDED',
  DiscussionSubscriptionEventType.POST_DELETED: 'POST_DELETED',
  DiscussionSubscriptionEventType.PARTICIPANT_BANNED: 'PARTICIPANT_BANNED',
};
