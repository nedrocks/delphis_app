import 'package:delphis_app/widgets/emoji_picker/emoji_picker.dart';
import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';

class DiscussionNamingScreen extends StatefulWidget {
  final TextEditingController textController;
  final String selectedEmoji;
  final VoidCallback onSavePressed;
  final VoidCallback onClosePressed;

  DiscussionNamingScreen(
      {@required this.textController,
      @required this.selectedEmoji,
      @required this.onSavePressed,
      @required this.onClosePressed})
      : super();

  @override
  State<StatefulWidget> createState() {
    return _DiscussionNamingScreenState();
  }
}

class _DiscussionNamingScreenState extends State<DiscussionNamingScreen> {
  String _selectedEmoji;
  bool _isShowingEmojiSelector;

  @override
  void initState() {
    super.initState();

    this._selectedEmoji = this.widget.selectedEmoji;
    this._isShowingEmojiSelector = false;
  }

  @override
  Widget build(BuildContext context) {
    Widget contents = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Pressable(
              height: 50.0,
              width: 50.0,
              onPressed: this.widget.onClosePressed,
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
        ChathamEmojiPicker(
            selectedEmoji: this._selectedEmoji,
            width: 160.0,
            height: 160.0,
            onPressed: () {
              setState(() {
                this._isShowingEmojiSelector = true;
              });
            }),
        // Input(),
        // Button(),
      ],
    );
    if (this._isShowingEmojiSelector) {
      contents = Stack(
        children: [
          contents,
          EmojiPicker(
            columns: 6,
            onEmojiSelected: (emoji, _) {
              print('selected $emoji');
            },
          ),
        ],
      );
    }
    return Card(
      child: Container(
        height: (MediaQuery.of(context).size.height * 7 / 8),
        child: contents,
      ),
    );
  }
}
