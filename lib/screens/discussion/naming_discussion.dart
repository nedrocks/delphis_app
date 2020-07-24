import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/widgets/emoji_picker/emoji_picker.dart';
import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

typedef void NameCallback(
    BuildContext context, String selectedEmoji, String title);
typedef void ContextCallback(BuildContext context);

class DiscussionNamingScreen extends StatefulWidget {
  final String selectedEmoji;
  final String title;
  final NameCallback onSavePressed;
  final ContextCallback onClosePressed;

  static final emojiRegex = RegExp(
      r'^(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])+$');

  DiscussionNamingScreen({
    @required this.title,
    @required this.selectedEmoji,
    @required this.onSavePressed,
    @required this.onClosePressed,
  }) : super();

  @override
  State<StatefulWidget> createState() {
    return _DiscussionNamingScreenState();
  }
}

class _DiscussionNamingScreenState extends State<DiscussionNamingScreen> {
  String _selectedEmoji;

  FocusNode _emojiTextFocusNode;
  TextEditingController _emojiInputController;
  TextInputFormatter _emojiInputFormatter;

  FocusNode _titleTextFocusNode;
  TextEditingController _titleInputController;
  TextInputFormatter _titleInputFormatter;

  @override
  void initState() {
    super.initState();

    this._selectedEmoji = this.widget.selectedEmoji;

    this._emojiTextFocusNode = FocusNode();
    this._emojiInputController =
        TextEditingController(text: this._selectedEmoji);
    this._emojiInputFormatter =
        TextInputFormatter.withFunction((oldValue, newValue) {
      // Only emojis are accepted. We can have 1 or 2 runes. If 2 runes the second rune must
      // match the modifier.
      if (newValue.text.runes == null ||
          newValue.text.runes.length < 1 ||
          newValue.text.runes.length > 2) {
        return oldValue;
      }
      // Otherwise find matches.
      final regexMatch =
          DiscussionNamingScreen.emojiRegex.allMatches(newValue.text);
      if (regexMatch.length == 1) {
        final match = regexMatch.elementAt(0);
        if (match.start == 0 && match.end == newValue.text.length) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            this._emojiTextFocusNode.unfocus();
          });
          return newValue;
        }
      }
      return oldValue;
    });

    this._titleTextFocusNode = FocusNode();
    this._titleInputController = TextEditingController(text: this.widget.title);
    this._titleInputFormatter = TextInputFormatter.withFunction(
        (oldValue, newValue) => newValue.text.length > 24
            ? (oldValue.text.length > 24
                ? TextEditingValue(
                    composing: newValue.composing,
                    text: newValue.text.substring(0, 24),
                    selection: newValue.selection,
                  )
                : oldValue)
            : newValue);
  }

  @override
  Widget build(BuildContext context) {
    Widget contents = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SpacingValues.xxLarge),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Pressable(
              height: 35.0,
              width: 35.0,
              onPressed: () {
                this.widget.onClosePressed(context);
              },
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(33, 34, 39, 1.0),
              ),
              child: Container(
                child: Icon(
                  Icons.close,
                  color: Color.fromRGBO(79, 79, 85, 1.0),
                  semanticLabel: 'Close',
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Padding(
          padding: EdgeInsets.only(left: SpacingValues.smallMedium),
          child: ChathamEmojiPicker(
            width: 160.0,
            height: 160.0,
            textController: this._emojiInputController,
            textFocusNode: this._emojiTextFocusNode,
            formatter: this._emojiInputFormatter,
          ),
        ),
        SizedBox(height: 40.0, width: 0.0),
        TextField(
          enabled: true,
          showCursor: true,
          focusNode: this._titleTextFocusNode,
          controller: this._titleInputController,
          keyboardType: TextInputType.text,
          inputFormatters: [this._titleInputFormatter],
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
              letterSpacing: -0.22),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  color: Color.fromRGBO(227, 227, 237, 1.0),
                  onPressed: () {
                    this.widget.onSavePressed(
                        context,
                        this._emojiInputController.text,
                        this._titleInputController.text);
                  },
                  child: Container(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
    return Card(
      color: Color.fromRGBO(20, 23, 28, 1.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: SpacingValues.large),
        height: (MediaQuery.of(context).size.height * 7 / 8),
        child: contents,
      ),
    );
  }
}
