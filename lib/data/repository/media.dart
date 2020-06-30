
import 'dart:convert';
import 'dart:io';
import 'package:delphis_app/constants.dart';
import 'package:http/http.dart' as http;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart' as JsonAnnotation;

enum MediaType {
  IMAGE, VIDEO
}

class MediaRepository {

  Future<Media> uploadImage(File file) async {
    var request = http.MultipartRequest("POST", Uri.parse(Constants.uploadImageUrl));
    var pic = await http.MultipartFile.fromPath("image", file.path);
    request.files.add(pic);

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    if (response.statusCode != 200) {
      throw responseString;
    }
    return Media.fromJson(json.decode(responseString));
  }

}

@JsonAnnotation.JsonSerializable()
class Media extends Equatable {
  final String mediaId;
  final String mediaType;

  const Media({this.mediaId, this.mediaType});

  @override
  List<Object> get props =>[this.mediaId, this.mediaType];
  
  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
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