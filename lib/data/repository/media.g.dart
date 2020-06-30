// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaUpload _$MediaUploadFromJson(Map<String, dynamic> json) {
  return MediaUpload(
    mediaId: json['mediaId'] as String,
    mediaType: json['mediaType'] as String,
  );
}

Map<String, dynamic> _$MediaUploadToJson(MediaUpload instance) =>
    <String, dynamic>{
      'mediaId': instance.mediaId,
      'mediaType': instance.mediaType,
    };

Media _$MediaFromJson(Map<String, dynamic> json) {
  return Media(
    id: json['id'] as String,
    createdAt: json['createdAt'] as String,
    isDeleted: json['isDeleted'] as bool,
    mediaType: json['mediaType'] as String,
    mediaSize: json['mediaSize'] == null
        ? null
        : MediaSize.fromJson(json['mediaSize'] as Map<String, dynamic>),
    assetLocation: json['assetLocation'] as String,
  );
}

Map<String, dynamic> _$MediaToJson(Media instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'isDeleted': instance.isDeleted,
      'mediaType': instance.mediaType,
      'mediaSize': instance.mediaSize,
      'assetLocation': instance.assetLocation,
    };

MediaSize _$MediaSizeFromJson(Map<String, dynamic> json) {
  return MediaSize(
    height: json['height'] as int,
    width: json['width'] as int,
    sizeKb: (json['sizeKb'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$MediaSizeToJson(MediaSize instance) => <String, dynamic>{
      'height': instance.height,
      'width': instance.width,
      'sizeKb': instance.sizeKb,
    };
