import 'dart:io';

import 'package:delphis_app/data/repository/media.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:flutter/material.dart';

class MediaLoadedSnippet extends StatelessWidget {
  final File file;
  final ImageProvider image;
  final VoidCallback onTap;
  final MediaContentType mediaContentType;

  const MediaLoadedSnippet({
    Key key,
    @required this.file,
    @required this.image,
    @required this.onTap,
    @required this.mediaContentType
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: SpacingValues.small),
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.width * 0.75 * (9 / 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: this.onTap,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: image, fit: BoxFit.contain)),
            child: this.mediaContentType !=
                MediaContentType.VIDEO
                  ? Container()
                  : Center(
                      child: Container(
                        padding: EdgeInsets.all(SpacingValues.xxSmall),
                        decoration: BoxDecoration(
                          color: Colors.grey.withAlpha(200),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.play_arrow,
                          color: Colors.white, size: 25),
                      ),
                    ),
            ))),
    );
  }
  
}