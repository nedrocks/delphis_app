import 'package:delphis_app/models/user_profile.dart';
import 'package:delphis_app/widgets/anon_profile_image/anon_profile_image.dart';
import 'package:delphis_app/widgets/anon_profile_with_non_anon/anon_profile_with_non_anon.dart';
import 'package:delphis_app/widgets/profile_image/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoneIncognitoDiscussionPopupContents extends StatelessWidget {
  final UserProfile moderator;
  final VoidCallback onAccept;

  const GoneIncognitoDiscussionPopupContents({
    this.moderator,
    this.onAccept,
  }): super();

  String assholeMessage(String name) {
    return Intl.message('Don\'t be an asshole or it\'ll reflect badly on $name', args: [name]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 50.0,
      color: Colors.black,
      child: Container(
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 20.0,
              spreadRadius: 5.0,
              offset: Offset(
                0.0,
                -5.0,
              )
            )
          ],
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child:
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child:
              Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AnonProfileImageWithNonAnon(height: 100.0, width: 100.0, profileImageURL: this.moderator.profileImageURL),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    Intl.message('You\'ve gone incognito.'), 
                    style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    this.assholeMessage(this.moderator.displayName), 
                    style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  // TODO: I hate this -- not sure how to fix it though.
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: RaisedButton(
                    onPressed: this.onAccept,
                    child: Text(Intl.message('Agree'), style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w400)),
                    color: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                    ),
                  ),
                )
              ],
            ),
        ),
      ),
    );
  }
}