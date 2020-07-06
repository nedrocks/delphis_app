import 'dart:io';

import 'package:delphis_app/data/repository/media.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/screens/discussion/media/image_preview.dart';
import 'package:delphis_app/screens/discussion/media/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MediaPreviewWidget extends StatefulWidget {
  final File mediaFile;
  final MediaContentType mediaType;
  final VoidCallback onCancel;

  const MediaPreviewWidget({
    Key key,
    @required this.mediaFile,
    @required this.mediaType,
    @required this.onCancel,
  }) : super(key: key);

  @override
  _MediaPreviewWidgetState createState() => _MediaPreviewWidgetState();
}

class _MediaPreviewWidgetState extends State<MediaPreviewWidget> {
  int rotationQuarter;

  @override
  void initState() {
    this.rotationQuarter = 0;
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget render = Container();
    switch(this.widget.mediaType) { 
      case MediaContentType.IMAGE:
        render =  ImagePreviewWidget(imageFile: this.widget.mediaFile);
        break;
      case MediaContentType.VIDEO:
        render = VideoPreviewWidget(videoFile: this.widget.mediaFile);
        break;
    }

    /* Implement rotation */
    render = new RotatedBox(
      quarterTurns: rotationQuarter,
      child: render
    );

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: SpacingValues.xxxxLarge),
        color: Colors.black,
        child: Stack(
          children: [
            Center(child: render),

            /* Cancel button */
            Positioned(
              top:0,
              left: 15,
              child: Material(
                color: Colors.grey.withAlpha(80),
                type: MaterialType.circle,
                clipBehavior: Clip.antiAlias,
                child: Container(
                  padding: EdgeInsets.all(SpacingValues.small),
                  child: InkWell(      
                    onTap: () {
                      this.widget.onCancel();
                      return true;
                    },
                    child: Icon(Icons.close, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),

            /* Rotation button */
            Positioned(
              top: 0,
              right: 15,
              child: Material(
                color: Colors.grey.withAlpha(80),
                type: MaterialType.circle,
                clipBehavior: Clip.antiAlias,
                child: Container(
                  padding: EdgeInsets.all(SpacingValues.small),
                  child: InkWell(      
                    onTap: () {
                      setState(() {
                        this.rotationQuarter = (this.rotationQuarter + 1) % 2;
                      });
                      return true;
                    },
                    child: Icon(Icons.rotate_right, color: Colors.white, size: 32),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
    
  }

}