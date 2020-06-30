import 'dart:io';

import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/media.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import 'delphis_input.dart';

class DelphisInputMediaPopupWidget extends StatefulWidget {
  final Discussion discussion;
  final Participant participant;
  final bool isShowingParticipantSettings;
  final void Function(FocusNode) onParticipantSettingsPressed;
  final ScrollController parentScrollController;
  final TextEditingController textController;
  final FocusNode inputFocusNode;
  final Function(String,
    File,
    MediaContentType) onSubmit;
  final VoidCallback onParticipantMentionPressed;

  const DelphisInputMediaPopupWidget({Key key,
    @required this.discussion,
    @required this.participant,
    @required this.isShowingParticipantSettings,
    @required this.onParticipantSettingsPressed,
    @required this.parentScrollController,
    @required this.textController,
    @required this.inputFocusNode,
    @required this.onSubmit,
    @required this.onParticipantMentionPressed
  }) : super(key: key);
  
  @override
  _DelphisInputMediaPopupWidgetState createState() => _DelphisInputMediaPopupWidgetState();
}

class _DelphisInputMediaPopupWidgetState extends State<DelphisInputMediaPopupWidget> {
  final ImagePicker imagePicker = ImagePicker();
  File mediaFile;
  MediaContentType mediaType;

  @override
  Widget build(BuildContext context) {
    var bar = Container();
    if(mediaFile != null && mediaType != null) {
      bar = Container(
        padding: EdgeInsets.symmetric(horizontal : SpacingValues.small, vertical: SpacingValues.extraSmall),
        child: Text(mediaType.toString()),
      );
    }
    
    var render = Column(
      children: [
        bar,
        DelphisInput(
          discussion: widget.discussion,
          participant: widget.participant,
          isShowingParticipantSettings: widget.isShowingParticipantSettings,
          onParticipantSettingsPressed: widget.onParticipantSettingsPressed,
          parentScrollController: widget.parentScrollController,
          inputFocusNode: this.widget.inputFocusNode,
          textController: this.widget.textController,
          onParticipantMentionPressed: this.widget.onParticipantMentionPressed,
          onGalleryPressed: this.selectGalleryMedia,
          onImageCameraPressed: this.selectCameraImage,
          onVideoCameraPressed: this.selectCameraVideo,
          onSubmit: (text) {
            this.widget.onSubmit(text, this.mediaFile, this.mediaType);

            // Maybe we can interact with DiscussionBloc to catch errors and not discard the image
            setState(() {
              this.mediaFile = null;
              this.mediaType = null;
            });
          },
        )
      ],
    );
    return Platform.isAndroid
      ? FutureBuilder(
          future: retrieveLostData(),
          builder: (context, snapshot) => render,
        )
      : render;
  }

  void selectGalleryMedia() async {
    File mediaFile = await FilePicker.getFile(type: FileType.media);
    if(mediaFile != null) {
      String mimeStr = lookupMimeType(mediaFile.path);
      var fileType = mimeStr.split('/')[0].toLowerCase() == "image" ? MediaContentType.IMAGE : MediaContentType.VIDEO;
      setState(() {
        this.mediaFile = mediaFile;
        this.mediaType = fileType;
      });
    }
  }

  void selectCameraImage() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.camera);
    if(pickedFile != null) {
      setState(() {
        this.mediaFile = File(pickedFile.path);
        this.mediaType = MediaContentType.IMAGE;
      });
    }
  }

  void selectCameraVideo() async {
    final pickedFile = await imagePicker.getVideo(source: ImageSource.camera);
    if(pickedFile != null) {
      setState(() {
        this.mediaFile = File(pickedFile.path);
        this.mediaType = MediaContentType.VIDEO;
      });
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await imagePicker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      var mediaType = MediaContentType.IMAGE;
      if (response.type == RetrieveType.video) {
        mediaType = MediaContentType.VIDEO;
      }
      setState(() {
        this.mediaFile = File(response.file.path);
        this.mediaType = mediaType;
      });
    }
    else {
      //response.exception.code;
      // Maybe catch errors ?
    }
  }

}