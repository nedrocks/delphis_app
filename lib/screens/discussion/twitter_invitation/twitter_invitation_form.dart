import 'dart:async';
import 'dart:math';

import 'package:delphis_app/bloc/twitter_invitation/twitter_invitation_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/twitter_user.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/discussion/twitter_invitation/twitter_user_search_list_entry.dart';
import 'package:delphis_app/widgets/animated_size_container/animated_size_container.dart';
import 'package:delphis_app/widgets/go_back/go_back.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TwitterInvitationForm extends StatefulWidget {
  final Participant participant;
  final Discussion discussion;
  final VoidCallback onCancel;
  final double maxListEntriesBeforeScroll;

  TwitterInvitationForm(
      {@required this.onCancel,
      @required this.participant,
      @required this.discussion,
      this.maxListEntriesBeforeScroll = 2.5});

  @override
  _TwitterInvitationFormState createState() => _TwitterInvitationFormState();
}

class _TwitterInvitationFormState extends State<TwitterInvitationForm> {
  final autocompleteEntryHeight = 50.0;
  final queryDebouncher = _Debouncer(1000);
  TextEditingController textController;
  TwitterUserInfo selectedAutocomplete;
  int selectedAutocompleteIndex;

  @override
  void initState() {
    this.textController = TextEditingController();
    this.textController.addListener(() {
      setState(() {});
    });
    selectedAutocomplete = null;
    selectedAutocompleteIndex = -1;
    super.initState();
  }

  @override
  void dispose() {
    this.textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TwitterInvitationBloc, TwitterInvitationState>(
      builder: (context, state) {
        Widget contentWidget = Container();

        if (state is TwitterInvitationLoadingState ||
            queryDebouncher.isWaiting) {
          contentWidget = Container(
            margin: EdgeInsets.only(bottom: SpacingValues.mediumLarge),
            child: CupertinoActivityIndicator(),
          );
        } else if (state is TwitterInvitationSearchSuccessState) {
          var heightUnits = min(this.widget.maxListEntriesBeforeScroll,
              max(state.autocompletes.length, 1.2));
          if (state.autocompletes.length == 0) {
            contentWidget = Container(
              margin: EdgeInsets.only(bottom: SpacingValues.medium),
              child: Center(
                  child: Text(Intl.message(
                      "No results available for the given entry."))),
            );
          } else {
            contentWidget = Container(
              height: heightUnits * autocompleteEntryHeight,
              child: ListView.builder(
                  itemCount: state.autocompletes.length,
                  itemBuilder: (context, index) {
                    var element = state.autocompletes[index];
                    return TwitterUserSearchListEntry(
                      userInfo: element,
                      isChecked: element.invited,
                      isSelected: selectedAutocompleteIndex == index,
                      onTap: () {
                        setState(() {
                          selectedAutocompleteIndex = index;
                          selectedAutocomplete = element;
                        });
                      },
                    );
                  }),
            );
          }
        } else if (state is TwitterInvitationInviteSuccessState) {
          var message = "";
          if (state.invites.length == 0) {
            message = Intl.message("No invitation has been sent.");
          } else if (state.invites.length == 1) {
            message =
                Intl.message("Your invitation has been successfully sent.");
          } else {
            message = Intl.message(
                "Your ${state.invites.length} invitations has been successfully sent.");
          }
          contentWidget = Container(
            margin: EdgeInsets.only(bottom: SpacingValues.medium),
            child: Center(
                child: Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Colors.green),
              textAlign: TextAlign.center,
            )),
          );
        } else if (state is TwitterInvitationErrorState) {
          contentWidget = Container(
            margin: EdgeInsets.only(bottom: SpacingValues.medium),
            child: Center(
                child: Text(
              state.error.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Colors.red),
              textAlign: TextAlign.center,
            )),
          );
        }
        if (this.textController.text.length == 0) {
          contentWidget = Container();
        }

        var textStyle = Theme.of(context).textTheme.bodyText2;
        var hintStyle =
            textStyle.copyWith(color: Color.fromRGBO(81, 82, 88, 1.0));
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
                Container(
                    height: 1.0, color: Color.fromRGBO(110, 111, 121, 0.6)),
                SizedBox(height: SpacingValues.medium),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: SpacingValues.medium),
                  child: Column(
                    children: [
                      Text(
                        Intl.message(
                            "Search a Twitter user you wish to invite in this discussion and select them from the list."),
                        style: TextThemes.goIncognitoSubheader,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: SpacingValues.medium),
                      AnimatedSizeContainer(
                        builder: (context) {
                          return contentWidget;
                        },
                      ),
                      TextField(
                          autofocus: true,
                          showCursor: true,
                          controller: this.textController,
                          style: textStyle,
                          decoration: InputDecoration(
                            counter: Container(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 13.0),
                            hintStyle: hintStyle,
                            hintText:
                                Intl.message("Type a Twitter username..."),
                            fillColor: Color.fromRGBO(57, 58, 63, 0.4),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          maxLength: 60,
                          onChanged: (value) =>
                              this.onTextChanged(context, value)),
                      SizedBox(height: SpacingValues.medium),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: this.widget.onCancel,
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: SpacingValues.xxLarge,
                                  vertical: SpacingValues.mediumLarge),
                              child: GoBack(height: 16.0, onPressed: null),
                            ),
                          ),
                          RaisedButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: SpacingValues.xxLarge,
                                vertical: SpacingValues.medium),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            color: this.textController.text.length == 0
                                ? Color.fromRGBO(247, 247, 255, 0.2)
                                : Color.fromRGBO(247, 247, 255, 1.0),
                            child: Text(Intl.message('Invite'),
                                style: this.textController.text.length == 0
                                    ? TextThemes.goIncognitoButton
                                    : TextThemes.joinButtonTextChatTab),
                            onPressed: selectedAutocomplete == null
                                ? null
                                : () {
                                    BlocProvider.of<TwitterInvitationBloc>(
                                            context)
                                        .add(TwitterInvitationInviteEvent(
                                            discussionID:
                                                this.widget.discussion?.id,
                                            invitingParticipantID: this
                                                .widget
                                                .discussion
                                                ?.meParticipant
                                                ?.id,
                                            invitedTwitterUsers: [
                                          TwitterUserInput(
                                              name: this
                                                  .selectedAutocomplete
                                                  .name)
                                        ]));
                                  },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: SpacingValues.mediumLarge),
              ]),
        );
      },
    );
  }

  void onTextChanged(BuildContext context, String value) {
    if (value == null || value.length == 0) {
      BlocProvider.of<TwitterInvitationBloc>(context)
          .add(TwitterInvitationResetEvent());
      return;
    }

    queryDebouncher.run(() {
      BlocProvider.of<TwitterInvitationBloc>(context).add(
          TwitterInvitationSearchEvent(
              query: value,
              discussionID: this.widget.discussion.id,
              invitingParticipantID: this.widget.participant.id));
      setState(() {
        selectedAutocomplete = null;
        selectedAutocompleteIndex = -1;
      });
    });
  }
}

class _Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  _Debouncer(this.milliseconds);

  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  bool get isWaiting {
    return _timer?.isActive ?? false;
  }
}
