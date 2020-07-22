import 'dart:ui';

import 'package:delphis_app/bloc/superpowers/superpowers_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/discussion/overlay/superpowers_popup_option.dart';
import 'package:delphis_app/screens/discussion/screen_args/superpowers_arguments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SuperpowersPopup extends StatelessWidget {
  final SuperpowersArguments arguments;
  final VoidCallback onCancel;

  const SuperpowersPopup(
      {Key key, @required this.arguments, @required this.onCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuperpowersBloc, SuperpowersState>(
      builder: (context, state) {
        /* Format error messages */
        Widget bottomWidget = Container();
        if (state is ErrorState) {
          bottomWidget = Column(
            children: [
              Text(
                state.message,
                style: TextThemes.goIncognitoButton.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SpacingValues.medium),
            ],
          );
        }

        /* Format operation success messages */
        if (state is SuccessState) {
          /* Dismiss the popup if the result is successful */
          SchedulerBinding.instance.addPostFrameCallback((_) {
            this.onCancel();
          });
        }

        /* Format loading status */
        if (state is LoadingState) {
          bottomWidget = Column(
            children: [
              CupertinoActivityIndicator(),
              SizedBox(height: SpacingValues.medium),
            ],
          );
        }

        /* Render popup */
        return SafeArea(
          child: Card(
            elevation: 50.0,
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.only(
                  left: SpacingValues.extraLarge,
                  right: SpacingValues.extraLarge,
                  top: SpacingValues.mediumLarge),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromRGBO(34, 35, 40, 1.0), width: 1.5),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36.0),
                      topRight: Radius.circular(36.0)),
                  color: Color.fromRGBO(22, 23, 28, 1.0)),
              child: Container(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                    Text(
                      isMeDiscussionModerator()
                          ? Intl.message("Mod Superpowers")
                          : Intl.message("User Superpowers"),
                      style: TextThemes.goIncognitoHeader,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SpacingValues.medium),
                    Container(
                        height: 1.0, color: Color.fromRGBO(110, 111, 121, 0.6)),
                    SizedBox(height: SpacingValues.small),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: buildOptionList(context),
                      ),
                    ),
                    SizedBox(height: SpacingValues.small),
                    bottomWidget,
                    Container(
                        height: 1.0, color: Color.fromRGBO(110, 111, 121, 0.6)),
                    SizedBox(height: SpacingValues.mediumLarge),
                    GestureDetector(
                        onTap: () {
                          this.onCancel();
                        },
                        child: Text(
                          Intl.message('Cancel'),
                          style: TextThemes.cancelText,
                        )),
                    SizedBox(height: SpacingValues.mediumLarge),
                  ])),
            ),
          ),
        );
      },
    );
  }

  /* This is overlay-safe */
  void showConfirmationDialog(BuildContext context, VoidCallback onConfirm) {
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      return SafeArea(
        child: Positioned.fill(
          child: GestureDetector(
            onTap: () => overlayEntry?.remove(),
            child: Container(
              color: Colors.black.withOpacity(0.45),
              child: Center(
                child: AlertDialog(
                  elevation: 0,
                  title: Text(Intl.message("Are you sure?")),
                  content: Text(
                      "This action will have irreversible effects, do you still desire to proceed?"),
                  actions: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                              child: Text(Intl.message("Cancel")),
                              onPressed: () => overlayEntry?.remove()),
                          FlatButton(
                            child: Text(Intl.message("Continue")),
                            onPressed: () {
                              overlayEntry?.remove();
                              onConfirm();
                            },
                          )
                        ],
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
    Overlay.of(context).insert(overlayEntry);
  }

  List<Widget> buildOptionList(BuildContext context) {
    List<Widget> list = [];

    /* Delete post feature */
    if (arguments.post != null &&
        !arguments.post.isDeleted &&
        (isMeDiscussionModerator() || isMePostAuthor())) {
      list.add(ModeratorPopupOption(
        child: Image.asset("assets/images/app_icon/image.png"),
        title: Intl.message("Delete post"),
        description: Intl.message("Remove this post from the discussion."),
        onTap: () => showConfirmationDialog(context, () {
          BlocProvider.of<SuperpowersBloc>(context).add(DeletePostEvent(
              discussion: this.arguments.discussion,
              post: this.arguments.post));
          return true;
        }),
      ));
    }

    /* Ban participant feature */
    if (arguments.participant != null &&
        arguments.post != null &&
        isMeDiscussionModerator() &&
        !isMePostAuthor()) {
      list.add(ModeratorPopupOption(
          child: Image.asset("assets/images/app_icon/image.png"),
          title: Intl.message("Kick participant"),
          description:
              Intl.message("Ban the author of this post from the discussion."),
          onTap: () => showConfirmationDialog(context, () {
                BlocProvider.of<SuperpowersBloc>(context).add(
                    BanParticipantEvent(
                        discussion: this.arguments.discussion,
                        participant: this.arguments.post.participant));
                return true;
              })));
    }

    /* A user could have no actions avaliable */
    if (list.length == 0) {
      list.add(Container(
        height: 80,
        child: Center(
          child: Text(Intl.message("There are no actions available."),
              style: TextThemes.goIncognitoOptionName),
        ),
      ));
    }

    return list;
  }

  bool isMeDiscussionModerator() {
    return this.arguments?.discussion?.isMeDiscussionModerator() ?? false;
  }

  bool isMePostAuthor() {
    return this.arguments.post != null &&
        (this
                .arguments
                .discussion
                ?.meAvailableParticipants
                ?.where((e) => e.discussion.id == this.arguments.discussion.id)
                ?.map((e) => e.participantID)
                ?.contains(this.arguments.post.participant?.participantID) ??
            false);
  }
}
