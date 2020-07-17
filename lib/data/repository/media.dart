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
    ReceivePort receivePort = ReceivePort();
    Isolate.spawn(
        _compressImage, _CompressImageParam(file, receivePort.sendPort));
    List<int> bytes = await receivePort.first;

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
    Image image = decodeImage(param.file.readAsBytesSync());
    param.sendPort.send(encodeJpg(image, quality: 60));
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
