import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatelessWidget {
  final File imageFile;

  const ImagePreviewWidget({Key key, @required this.imageFile}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Image.file(
      imageFile,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    ); 
  }
}