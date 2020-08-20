
import 'dart:io';

import 'package:delphis_app/data/repository/media.dart';
import 'package:flutter/material.dart';

class MediaChangeNotifier extends ChangeNotifier {
  ImageProvider imageProvider;
  MediaContentType mediaContentType;
  File file;

  bool hasData() {
    return file != null && imageProvider != null && mediaContentType != null;
  }
  void setData(File file, ImageProvider imageProvider, MediaContentType mediaContentType) {
    this.file = file;
    this.imageProvider = imageProvider;
    this.mediaContentType = mediaContentType;
    this.notifyListeners();
  }

}