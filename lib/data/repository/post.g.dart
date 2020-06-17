// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    id: json['id'] as String,
    isDeleted: json['isDeleted'] as bool,
    deletedReasonCode: _$enumDecodeNullable(
        _$PostDeletedReasonEnumMap, json['deletedReasonCode']),
    content: json['content'] as String,
    discussion: json['discussion'] == null
        ? null
        : Discussion.fromJson(json['discussion'] as Map<String, dynamic>),
    participant: json['participant'] == null
        ? null
        : Participant.fromJson(json['participant'] as Map<String, dynamic>),
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
    isLocalPost: json['isLocalPost'] as bool,
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'deletedReasonCode':
          _$PostDeletedReasonEnumMap[instance.deletedReasonCode],
      'content': instance.content,
      'discussion': instance.discussion,
      'participant': instance.participant,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isLocalPost': instance.isLocalPost,
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

const _$PostDeletedReasonEnumMap = {
  PostDeletedReason.UNKNOWN: 'UNKNOWN',
  PostDeletedReason.MODERATOR_REMOVED: 'MODERATOR_REMOVED',
  PostDeletedReason.PARTICIPANT_REMOVED: 'PARTICIPANT_REMOVED',
};

PostsEdge _$PostsEdgeFromJson(Map<String, dynamic> json) {
  return PostsEdge(
    cursor: json['cursor'] as String,
    node: json['node'] == null
        ? null
        : Post.fromJson(json['node'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PostsEdgeToJson(PostsEdge instance) => <String, dynamic>{
      'cursor': instance.cursor,
      'node': instance.node,
    };

PostsConnection _$PostsConnectionFromJson(Map<String, dynamic> json) {
  return PostsConnection(
    edges: (json['edges'] as List)
        ?.map((e) =>
            e == null ? null : PostsEdge.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    pageInfo: json['pageInfo'] == null
        ? null
        : PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PostsConnectionToJson(PostsConnection instance) =>
    <String, dynamic>{
      'edges': instance.edges,
      'pageInfo': instance.pageInfo,
    };
