import 'dart:io';

import 'package:delphis_app/data/repository/media.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:transparent_image/transparent_image.dart';

class MediaInputSnippetWidget extends StatelessWidget {
  final File mediaFile;
  final MediaContentType mediaType;
  final Function(File, MediaContentType) onTap;
  final Function(File, MediaContentType) onCancelTap;

  const MediaInputSnippetWidget({
    Key key,
    @required this.mediaFile,
    @required this.mediaType,
    @required this.onTap,
    @required this.onCancelTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getImage(),
      builder: (context, snapshot) {
        ImageProvider imageProvider = MemoryImage(kTransparentImage);
        if(snapshot.hasData)
          imageProvider = snapshot.data;

        return Container(
          child: Stack(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(
                    top: SpacingValues.small,
                    bottom: SpacingValues.small,
                    left: SpacingValues.small,
                    right: SpacingValues.medium
                  ),
                  width: 120,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)
                    ),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fitWidth
                    )
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => this.onTap(this.mediaFile, this.mediaType),
                      child: this.mediaType != MediaContentType.VIDEO
                        ? Container()
                        : Center(
                          child: Container(
                            padding: EdgeInsets.all(SpacingValues.xxSmall),
                            decoration: BoxDecoration(
                              color: Colors.grey.withAlpha(200),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.play_arrow, color: Colors.white, size: 25),
                          ),
                        ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 0,
                right: 0,
                child: Material(
                  color: Colors.black,
                  type: MaterialType.circle,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(  
                    onTap: () => this.onCancelTap(this.mediaFile, this.mediaType),
                    child: Icon(Icons.cancel, color: Colors.white, size: SpacingValues.medium * 2),
                  )
                ),
              ),
            ],
          )
        );
      },
    );
  }

  Future<ImageProvider> getImage() {
    switch(this.mediaType) {      
      case MediaContentType.IMAGE:
        return Future.value(FileImage(mediaFile));
      case MediaContentType.VIDEO:
        return VideoThumbnail.thumbnailData(
          video: this.mediaFile.path,
          imageFormat: ImageFormat.PNG,
          maxHeight: 90,
        ).then((value) => MemoryImage(value));
    }
    return null;
  }

}