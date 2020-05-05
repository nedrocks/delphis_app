// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Flair _$FlairFromJson(Map<String, dynamic> json) {
  return Flair(
    id: json['id'] as String,
    displayName: json['displayName'] as String,
    imageURL: json['imageURL'] as String,
    source: json['source'] as String,
  );
}

Map<String, dynamic> _$FlairToJson(Flair instance) => <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'imageURL': instance.imageURL,
      'source': instance.source,
    };
