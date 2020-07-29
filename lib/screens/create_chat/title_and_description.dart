import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'base_chat_screen.dart';

typedef void TitleAndDescriptionComplete(String title, String description);

class CreateChatTitleAndDescriptionScreen extends StatefulWidget {
  static const _headingText =
      'This lets you create a new conversation for which you will be the moderator. Your identity will be visible to everyone but all participants will be anonymous to each other (and you).';

  final String title;
  final String description;

  final TitleAndDescriptionComplete onComplete;
  final VoidCallback onCancel;

  const CreateChatTitleAndDescriptionScreen({
    @required this.title,
    @required this.description,
    @required this.onComplete,
    @required this.onCancel,
  }) : super();

  @override
  State<StatefulWidget> createState() => _CreateChatTitleAndDescriptionScreen();
}

class _CreateChatTitleAndDescriptionScreen
    extends State<CreateChatTitleAndDescriptionScreen> {
  FocusNode _titleFocusNode;
  TextEditingController _titleInputController;

  FocusNode _descriptionFocusNode;
  TextEditingController _descriptionInputController;

  @override
  void initState() {
    super.initState();

    this._titleFocusNode = FocusNode();
    this._titleInputController =
        TextEditingController(text: this.widget.title ?? '');

    this._descriptionFocusNode = FocusNode();
    this._descriptionInputController =
        TextEditingController(text: this.widget.description ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final contents = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SpacingValues.xxLarge),
        Text(Intl.message(CreateChatTitleAndDescriptionScreen._headingText),
            style: TextThemes.emojiPickerText),
        SizedBox(height: SpacingValues.medium),
        Text(Intl.message('Enter a title for your chat:'),
            style: TextThemes.discussionPostAuthorAnon),
        SizedBox(height: SpacingValues.xxSmall),
        TextField(
          enabled: true,
          showCursor: true,
          focusNode: this._titleFocusNode,
          controller: this._titleInputController,
          keyboardType: TextInputType.text,
          maxLines: 1,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                left: SpacingValues.smallMedium, bottom: SpacingValues.medium),
            fillColor: Colors.blue,
            filled: false,
          ),
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w700,
            height: 1.0,
            letterSpacing: -0.22,
          ),
        ),
        SizedBox(height: SpacingValues.medium),
        Text(Intl.message('A description for your chat:'),
            style: TextThemes.discussionPostAuthorAnon),
        SizedBox(height: SpacingValues.xxSmall),
        TextField(
          enabled: true,
          showCursor: true,
          focusNode: this._descriptionFocusNode,
          controller: this._descriptionInputController,
          keyboardType: TextInputType.text,
          maxLines: 1,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                left: SpacingValues.smallMedium, bottom: SpacingValues.medium),
            fillColor: Colors.blue,
            filled: false,
          ),
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w700,
            height: 1.0,
            letterSpacing: -0.22,
          ),
        ),
      ],
    );

    return BaseCreateChatScreen(
      title: "Title and Description",
      onContinue: () {
        final title = this._titleInputController.text;
        final description = this._descriptionInputController.text;
        if (title != null && title.length > 0) {
          this.widget.onComplete(title, description);
        }
      },
      onCancel: this.widget.onCancel,
      contents: contents,
    );
  }
}
