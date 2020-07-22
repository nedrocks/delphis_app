import 'dart:io';
import 'dart:typed_data';

import 'package:delphis_app/data/repository/media.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/screens/discussion/media/media_loaded_snippet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaSnippetWidget extends StatefulWidget {
  final Post post;
  final Function(File, MediaContentType) onTap;
  final Function(File, ImageProvider, MediaContentType) onMediaLoaded;

  const MediaSnippetWidget({
    Key key,
    @required this.onTap,
    @required this.post,
    @required this.onMediaLoaded
  }) : super(key: key);

  @override
  _MediaSnippetWidgetState createState() => _MediaSnippetWidgetState();
}

class _MediaSnippetWidgetState extends State<MediaSnippetWidget> {
  ImageProvider imageProvider;
  File imageFile;

  @override
  void initState() {
    if (this.widget.post.isLocalPost ?? false) {
      this.imageFile = this.widget.post.localMediaFile;
      this.imageProvider = FileImage(this.widget.post.localMediaFile);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (imageFile != null && imageProvider != null) {
      return LoadedMediaSnippetWidget(
        mediaContentType: this.widget.post.media?.mediaContentType ??
          this.widget.post.localMediaContentType,
        file: this.imageFile,
        image: this.imageProvider,
        onTap: () => this.widget.onTap(imageFile, this.widget.post.media?.mediaContentType ?? null)
      );
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: SpacingValues.small),
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.width * 0.75 * (9 / 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), color: Colors.grey),
      child: FutureBuilder(
        future: downloadFile(
            this.widget.post.media?.assetLocation ?? "", this.widget.post.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (snapshot.hasData) {
            return FutureBuilder(
              future: getImage(snapshot.data,
                  this.widget.post.media?.mediaContentType ?? null),
              builder: (context, imageSnapshot) {
                if (imageSnapshot.hasError) {
                  return Center(
                    child: Text(imageSnapshot.error.toString()),
                  );
                }

                if (imageSnapshot.hasData) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    setState(() {
                      this.imageProvider = imageSnapshot.data;
                      this.imageFile = snapshot.data;
                    });
                    if(this.widget.onMediaLoaded != null)
                      this.widget.onMediaLoaded(snapshot.data, imageSnapshot.data, this.widget.post.media?.mediaContentType ??
                        this.widget.post.localMediaContentType);
                  });
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

  Future<ImageProvider> getImage(
      File mediaFile, MediaContentType mediaType) async {
    if (this.imageProvider != null) {
      return Future.value(this.imageProvider);
    }

    /* Read file contents */
    Uint8List bytesContent;
    try {
      bytesContent = mediaFile.readAsBytesSync();
    } catch (error) {
      return Future.error("FileSystem error");
    }

    /* Try to catch the unexistent-media error */
    try {
      var strContent = String.fromCharCodes(bytesContent);
      if (strContent.contains("<Error>") &&
          strContent.contains("<Code>NoSuchKey</Code>")) {
        return Future.error("This media does not exist");
      }
    } catch (error) {
      /* If it's not a UTF-8 string then it's probably a correct media */
    }

    switch (mediaType) {
      case MediaContentType.IMAGE:
        return MemoryImage(bytesContent);
      case MediaContentType.VIDEO:
        var thumbnail = await VideoThumbnail.thumbnailData(
            video: mediaFile.path, imageFormat: ImageFormat.PNG);
        return MemoryImage(thumbnail);
    }
    return Future.error("Unknown MediaContentType: $mediaType");
  }

  Future<File> downloadFile(String url, String filename) async {
    if (this.imageFile != null) return Future.value(imageFile);
    return await DefaultCacheManager().getSingleFile(url);
  }
}
