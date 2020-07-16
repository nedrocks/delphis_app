import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/widgets/go_back/go_back.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InviteTwitterUserPopup extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(String) onSubmit;
  
  InviteTwitterUserPopup({
    @required this.onCancel,
    @required this.onSubmit
  });

  @override
  _InviteTwitterUserPopupState createState() => _InviteTwitterUserPopupState();
}

class _InviteTwitterUserPopupState extends State<InviteTwitterUserPopup> {
  TextEditingController textController;

  @override
  void initState() {
    this.textController = TextEditingController();
    this.textController.addListener(() {
      setState(() {    
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    this.textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.bodyText2;
    var hintStyle = textStyle.copyWith(color: Color.fromRGBO(81, 82, 88, 1.0));
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            Intl.message("Invite Twitter User"),
            style: TextThemes.goIncognitoHeader,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: SpacingValues.medium),
          Container(height: 1.0, color: Color.fromRGBO(110, 111, 121, 0.6)),
          SizedBox(height: SpacingValues.small),
          
          Container(
            margin: EdgeInsets.symmetric(horizontal: SpacingValues.medium),
            child: Column(
              children: [
                Text(
                  Intl.message("Type the Twitter username of the person you wish to invite in this discussion."),
                  style: TextThemes.goIncognitoSubheader,
                  textAlign: TextAlign.center,
                ),           
                SizedBox(height: SpacingValues.medium),
                TextField(
                  autofocus: true,
                  showCursor: true,
                  controller: this.textController,
                  style: textStyle,
                  decoration: InputDecoration(
                    counter: Container(),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 13.0),
                    hintStyle: hintStyle,
                    hintText: Intl.message("Type a Twitter username..."),
                    fillColor: Color.fromRGBO(57, 58, 63, 0.4),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 1,
                  maxLength: 15,
                  
                ),
                SizedBox(height: SpacingValues.medium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GoBack(height: 16.0, onPressed: this.widget.onCancel),
                    RaisedButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: SpacingValues.xxLarge,
                        vertical: SpacingValues.medium
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)
                      ),
                      color: this.textController.text.length == 0 ? Color.fromRGBO(247, 247, 255, 0.2) : Color.fromRGBO(247, 247, 255, 1.0),
                      child: Text(
                        Intl.message('Invite'),
                        style: this.textController.text.length == 0 ? TextThemes.goIncognitoButton : TextThemes.joinButtonTextChatTab
                      ),
                      onPressed: this.textController.text.length == 0 ? null : () {
                        this.widget.onSubmit(this.textController.text);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),

          SizedBox(height: SpacingValues.mediumLarge),
        ]
      ),
    );
  }
}