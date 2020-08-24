import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:delphis_app/constants.dart';
import 'package:http/http.dart' as http;

import 'package:equatable/equatable.dart';
import 'package:image/image.dart';
import 'package:json_annotation/json_annotation.dart' as JsonAnnotation;

part 'media.g.dart';

enum MediaContentType { IMAGE, VIDEO }

class _CompressImageParam {
  final File file;
  final SendPort sendPort;
  _CompressImageParam(this.file, this.sendPort);
}

class MediaRepository {
  Future<MediaUpload> uploadImage(File file) async {
    final maxMediaSizeInBytes = 2 * 1024 * 1024;
    ReceivePort receivePort = ReceivePort();
    Isolate.spawn(
        _compressImage, _CompressImageParam(file, receivePort.sendPort));
    List<int> bytes = await receivePort.first;
    receivePort.close();

    /* Limit media size to 2 MB */
    if (bytes.length > maxMediaSizeInBytes) {
      throw "Can't upload media files larger than 2MB";
    }

    var request =
        http.MultipartRequest("POST", Uri.parse(Constants.uploadImageUrl));
    var pic = http.MultipartFile.fromBytes("image", bytes, filename: file.path);
    request.files.add(pic);

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    if (response.statusCode != 200) {
      throw responseString;
    }
    return MediaUpload.fromJson(json.decode(responseString));
  }

  static void _compressImage(_CompressImageParam param) {
    final maxWidth = 1000;
    final maxHeight = 1000;

    /* Resize image trying to maintain original aspect ratio */
    Image image = decodeImage(param.file.readAsBytesSync());
    if (image.width > maxWidth || image.height < maxHeight) {
      if (image.width > image.height) {
        image = copyResize(image, width: maxWidth);
      } else {
        image = copyResize(image, height: maxHeight);
      }
    }

    /* Compress image by reducing quality */
    var bytes = encodeJpg(image, quality: 70);

    /* Return edited image */
    param.sendPort.send(bytes);
  }
}

@JsonAnnotation.JsonSerializable()
class MediaUpload extends Equatable {
  final String mediaId;
  final String mediaType;

  const MediaUpload({this.mediaId, this.mediaType});

  @override
  List<Object> get props => [this.mediaId, this.mediaType];

  factory MediaUpload.fromJson(Map<String, dynamic> json) {
    return MediaUpload(
        mediaId: json['media_id'] as String,
        mediaType: json['media_type'] as String);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'media_id': this.mediaId,
      'media_type': this.mediaType,
    };
  }
}

@JsonAnnotation.JsonSerializable()
class Media extends Equatable {
  final String id;
  final String createdAt;
  final bool isDeleted;
  final String mediaType;
  final MediaSize mediaSize;
  final String assetLocation;

  const Media(
      {this.id,
      this.createdAt,
      this.isDeleted,
      this.mediaType,
      this.mediaSize,
      this.assetLocation});

  @override
  List<Object> get props =>
      [id, createdAt, isDeleted, mediaType, mediaSize, assetLocation];

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

  Map<String, dynamic> toJSON() {
    return _$MediaToJson(this);
  }

  DateTime createdAtAsDateTime() {
    return DateTime.parse(this.createdAt);
  }

  MediaContentType get mediaContentType {
    return mediaType.split('/')[0].toLowerCase() == "image"
        ? MediaContentType.IMAGE
        : MediaContentType.VIDEO;
  }
}

@JsonAnnotation.JsonSerializable()
class MediaSize extends Equatable {
  final int height;
  final int width;
  final double sizeKb;

  const MediaSize({this.height, this.width, this.sizeKb});

  @override
  List<Object> get props => [height, width, sizeKb];

  factory MediaSize.fromJson(Map<String, dynamic> json) =>
      _$MediaSizeFromJson(json);

  Map<String, dynamic> toJSON() {
    return _$MediaSizeToJson(this);
  }
}
