// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_content_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostContentInput _$PostContentInputFromJson(Map<String, dynamic> json) {
  return PostContentInput(
    postText: json['postText'] as String,
    postType: _$enumDecodeNullable(_$PostTypeEnumMap, json['postType']),
    mentionedEntities:
        (json['mentionedEntities'] as List)?.map((e) => e as String)?.toList(),
    quotedPostID: json['quotedPostID'] as String,
    mediaID: json['mediaID'] as String,
  );
}

Map<String, dynamic> _$PostContentInputToJson(PostContentInput instance) =>
    <String, dynamic>{
      'postText': instance.postText,
      'postType': _$PostTypeEnumMap[instance.postType],
      'mentionedEntities': instance.mentionedEntities,
      'quotedPostID': instance.quotedPostID,
      'mediaID': instance.mediaID,
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

const _$PostTypeEnumMap = {
  PostType.STANDARD: 'STANDARD',
  PostType.IMPORTED_CONTENT: 'IMPORTED_CONTENT',
  PostType.ALERT: 'ALERT',
};
