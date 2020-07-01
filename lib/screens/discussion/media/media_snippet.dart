import 'dart:io';
import 'dart:typed_data';

import 'package:delphis_app/data/repository/media.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:http/http.dart' as http;

class MediaSnippetWidget extends StatelessWidget {
  final Media media;
  final Function(File, MediaContentType) onTap;

  const MediaSnippetWidget({
    Key key,
    @required this.onTap, 
    @required this.media,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: SpacingValues.small),
      width: 200,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey
      ),
      child: FutureBuilder(
        future: downloadFile(this.media.assetLocation, this.media.id),
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if(snapshot.hasData) {
            return FutureBuilder(
              future: getImage(snapshot.data, this.media.mediaContentType),
              builder: (context, imageSnapshot) {
                if(imageSnapshot.hasError) {
                  return Center(
                    child: Text(imageSnapshot.error.toString()),
                  );
                }

                if(imageSnapshot.hasData) {
                  return Material(
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => this.onTap(snapshot.data, this.media.mediaContentType),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageSnapshot.data,
                            fit: BoxFit.fitWidth
                          )
                        ),
                        child: this.media.mediaContentType != MediaContentType.VIDEO
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
                      )
                    )
                  );
                }

                return Center(
                  child: CupertinoActivityIndicator(),
                );
              },
            );
          }

          return Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }

  Future<ImageProvider> getImage(File mediaFile, MediaContentType mediaType) async {
    /* Read file contents */
    Uint8List bytesContent;
    try {
      bytesContent = mediaFile.readAsBytesSync();
    }
    catch(error) {
      return Future.error("FileSystem error");
    }

    /* Try to catch the unexistent-media error */
    try {
      var strContent = String.fromCharCodes(bytesContent);
      if(strContent.contains("<Error>") && strContent.contains("<Code>NoSuchKey</Code>")) {
        return Future.error("This media does not exist");
      }
    }
    catch(error) { 
      /* If it's not a UTF-8 string then it's probably a correct media */
    }

    switch(mediaType) {
      case MediaContentType.IMAGE:
        return MemoryImage(bytesContent);
      case MediaContentType.VIDEO:
        var thumbnail = await VideoThumbnail.thumbnailData(
          video: mediaFile.path,
          imageFormat: ImageFormat.PNG);
        return MemoryImage(thumbnail);
    }
    return Future.error("Unknown MediaContentType: $mediaType");
  }

  Future<File> downloadFile(String url, String filename) async {
    var req = await http.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/media-$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

}
