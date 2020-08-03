import 'dart:ui';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:delphis_app/bloc/superpowers/superpowers_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/discussion/overlay/overlay_alert_dialog.dart';
import 'package:delphis_app/screens/discussion/overlay/superpowers/superpowers_popup_option.dart';
import 'package:delphis_app/screens/superpowers/superpowers_arguments.dart';
import 'package:delphis_app/widgets/animated_size_container/animated_size_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SuperpowersPopup extends StatefulWidget {
  final SuperpowersArguments arguments;
  final VoidCallback onCancel;

  const SuperpowersPopup(
      {Key key, @required this.arguments, @required this.onCancel})
      : super(key: key);

  @override
  _SuperpowersPopupState createState() => _SuperpowersPopupState();
}

class _SuperpowersPopupState extends State<SuperpowersPopup> {
  Widget panelToShow;
  OverlayEntry lastOverlayEntry;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(this.androidBackbuttonInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(this.androidBackbuttonInterceptor);
    super.dispose();
  }

  bool androidBackbuttonInterceptor(bool value) {
    removeConfirmationDialog();
    return value;
  }

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
            this.widget.onCancel();
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

        var toRender;
        if (panelToShow != null) {
          toRender = panelToShow;
        } else {
          toRender = Container(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                Text(
                  Intl.message("Post Actions"),
                  style: TextThemes.goIncognitoHeader,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SpacingValues.medium),
                Container(
                    height: 1.0, color: Color.fromRGBO(110, 111, 121, 0.6)),
                SizedBox(height: SpacingValues.small),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: 300,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: buildOptionList(context),
                    ),
                  ),
                ),
                SizedBox(height: SpacingValues.small),
                AnimatedSizeContainer(
                  builder: (context) {
                    return bottomWidget;
                  },
                ),
                Container(
                    height: 1.0, color: Color.fromRGBO(110, 111, 121, 0.6)),
                GestureDetector(
                    onTap: () {
                      this.widget.onCancel();
                    },
                    child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                            horizontal: SpacingValues.xxLarge,
                            vertical: SpacingValues.mediumLarge),
                        child: Text(
                          Intl.message('Close'),
                          style: TextThemes.backButton,
                        ))),
              ]));
        }

        /* Render popup */
        return SafeArea(
            child: Card(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
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
                    child: toRender)));
      },
    );
  }

  /* This is overlay-safe */
  void showConfirmationDialog(BuildContext context, VoidCallback onConfirm) {
    OverlayEntry overlayEntry;
    overlayEntry = OverlayAlertDialog(
      title: Container(
        margin: EdgeInsets.only(bottom: SpacingValues.smallMedium),
        child: Text(Intl.message("Are you sure?"),
            style: TextThemes.goIncognitoHeader),
      ),
      content: Text(
        "This action will have irreversible effects, do you still desire to proceed?",
        style: TextThemes.goIncognitoOptionName.copyWith(height: 1.25),
      ),
      actions: [
        CupertinoDialogAction(
            child: Text(Intl.message("Cancel")),
            onPressed: removeConfirmationDialog),
        CupertinoDialogAction(
          child: Text(Intl.message("Continue")),
          onPressed: () {
            removeConfirmationDialog();
            onConfirm();
          },
        )
      ],
    );
    Overlay.of(context).insert(overlayEntry);
    setState(() {
      lastOverlayEntry = overlayEntry;
    });
  }

  void removeConfirmationDialog() {
    lastOverlayEntry?.remove();
    if (mounted) {
      setState(() {
        lastOverlayEntry = null;
      });
    }
  }

  List<Widget> buildOptionList(BuildContext context) {
    List<Widget> list = [];

    /* Delete post feature */
    if (this.widget.arguments.post != null &&
        !this.widget.arguments.post.isDeleted &&
        (isMeDiscussionModerator() || isMePostAuthor())) {
      list.add(SuperpowersPopupOption(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SpacingValues.medium),
              color: Colors.black),
          clipBehavior: Clip.antiAlias,
          child: Icon(Icons.delete_forever, size: 40),
        ),
        title: Intl.message("Delete Post"),
        description: Intl.message(
            "Remove the selected post from this discussion, so that no participant will be able to read it."),
        onTap: () => showConfirmationDialog(context, () {
          BlocProvider.of<SuperpowersBloc>(context).add(DeletePostEvent(
              discussion: this.widget.arguments.discussion,
              post: this.widget.arguments.post));
          return true;
        }),
      ));
    }

    /* Ban participant feature */
    if (this.widget.arguments.participant != null &&
        this.widget.arguments.post != null &&
        isMeDiscussionModerator() &&
        !isMePostAuthor()) {
      list.add(SuperpowersPopupOption(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SpacingValues.medium),
                color: Colors.black),
            clipBehavior: Clip.antiAlias,
            child: Icon(Icons.block, size: 36),
          ),
          title: Intl.message("Kick Participant"),
          description: Intl.message(
              "Ban the author of the selected post from the discussion and delete every post they authored."),
          onTap: () => showConfirmationDialog(context, () {
                BlocProvider.of<SuperpowersBloc>(context).add(
                    BanParticipantEvent(
                        discussion: this.widget.arguments.discussion,
                        participant: this.widget.arguments.post.participant));
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
    return this.widget.arguments?.discussion?.isMeDiscussionModerator() ??
        false;
  }

  bool isMePostAuthor() {
    return this.widget.arguments.post != null &&
        (this
                .widget
                .arguments
                .discussion
                ?.meAvailableParticipants
                ?.where((e) =>
                    e.discussion.id == this.widget.arguments.discussion.id)
                ?.map((e) => e.participantID)
                ?.contains(
                    this.widget.arguments.post.participant?.participantID) ??
            false);
  }

  void cancelPanelToShow() {
    setState(() {
      this.panelToShow = null;
    });
    BlocProvider.of<SuperpowersBloc>(context).add(ResetEvent());
  }
}
