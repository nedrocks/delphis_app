import 'dart:io';

import 'package:delphis_app/data/repository/media.dart';
import 'package:delphis_app/screens/discussion/media_preview/image_preview.dart';
import 'package:delphis_app/screens/discussion/media_preview/video_preview.dart';
import 'package:flutter/material.dart';

class MediaPreviewWidget extends StatelessWidget {
  final File mediaFile;
  final MediaContentType mediaType;

  const MediaPreviewWidget({
    Key key,
    @required this.mediaFile,
    @required this.mediaType,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    switch(mediaType) { 
      case MediaContentType.IMAGE:
        return ImagePreviewWidget(imageFile: mediaFile);
      case MediaContentType.VIDEO:
        return VideoPreviewWidget(videoFile: mediaFile);
    }
    return Container();
  }

}