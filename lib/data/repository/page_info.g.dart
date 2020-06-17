// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageInfo _$PageInfoFromJson(Map<String, dynamic> json) {
  return PageInfo(
    startCursor: json['startCursor'] as String,
    endCursor: json['endCursor'] as String,
    hasNextPage: json['hasNextPage'] as bool,
  );
}

Map<String, dynamic> _$PageInfoToJson(PageInfo instance) => <String, dynamic>{
      'startCursor': instance.startCursor,
      'endCursor': instance.endCursor,
      'hasNextPage': instance.hasNextPage,
    };
