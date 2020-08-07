import 'dart:ui';

import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/bloc/superpowers/superpowers_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/superpowers/superpowers_arguments.dart';
import 'package:delphis_app/screens/superpowers_popup/mute_confirmation_dialog.dart';
import 'package:delphis_app/screens/superpowers_popup/superpowers_popup_option.dart';
import 'package:delphis_app/widgets/animated_size_container/animated_size_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SuperpowersPopupScreen extends StatefulWidget {
  final SuperpowersArguments arguments;

  const SuperpowersPopupScreen({
    Key key,
    @required this.arguments,
  }) : super(key: key);

  @override
  _SuperpowersPopupScreenState createState() => _SuperpowersPopupScreenState();
}

class _SuperpowersPopupScreenState extends State<SuperpowersPopupScreen> {
  Widget panelToShow;
  OverlayEntry lastOverlayEntry;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SuperpowersBloc, SuperpowersState>(
      listener: (context, state) {
        // Update local copies of discussion data
        if (state is MuteUnmuteParticipantSuccessState) {
          BlocProvider.of<DiscussionBloc>(context).add(
            DiscussionMuteUnmuteParticipantsRefreshEvent(state.participants),
          );
        } else if (state is BanParticipantSuccessState) {
          BlocProvider.of<DiscussionBloc>(context)
            ..add(
              DiscussionDeleteParticipantRefreshEvent(state.participant),
            )
            ..add(
              DiscussionDeleteParticipantPostsRefreshEvent(state.participant),
            );
        } else if (state is DeletePostSuccessState) {
          BlocProvider.of<DiscussionBloc>(context).add(
            DiscussionDeletePostRefreshEvent(state.post),
          );
        }
      },
      child: BlocBuilder<SuperpowersBloc, SuperpowersState>(
        builder: (context, state) {
          /* Format error messages */
          Widget bottomWidget = Container();
          if (state is ErrorState) {
            bottomWidget = Column(
              children: [
                Text(
                  state.message,
                  style:
                      TextThemes.goIncognitoButton.copyWith(color: Colors.red),
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
              Navigator.of(context).pop();
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
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: SpacingValues.xxLarge,
                          vertical: SpacingValues.mediumLarge),
                      child: Text(
                        Intl.message('Close'),
                        style: TextThemes.backButton,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          /* Render popup */
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Container(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Card(
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        elevation: 50.0,
                        color: Colors.transparent,
                        child: Container(
                          padding: EdgeInsets.only(
                            left: SpacingValues.extraLarge,
                            right: SpacingValues.extraLarge,
                            top: SpacingValues.mediumLarge,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromRGBO(34, 35, 40, 1.0),
                                width: 1.5),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(36.0),
                              topRight: Radius.circular(36.0),
                            ),
                            color: Color.fromRGBO(22, 23, 28, 1.0),
                          ),
                          child: toRender,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> showMuteConfirmationDialog(
      BuildContext context, Function(int) onConfirm) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MuteConfirmationDialog(
          onConfirm: onConfirm,
        );
      },
    );
  }

  Future<void> showConfirmationDialog(
      BuildContext context, VoidCallback onConfirm) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          insetAnimationCurve: Curves.easeInOut,
          insetAnimationDuration: Duration(milliseconds: 200),
          title: Container(
            margin: EdgeInsets.only(bottom: SpacingValues.smallMedium),
            child: Text(Intl.message("Are you sure?"),
                style: TextThemes.goIncognitoHeader),
          ),
          content: Text(
            "This action will have irreversible effects, do you still desire to proceed?",
            style: TextThemes.goIncognitoOptionName.copyWith(height: 1.25),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
                child: Text(Intl.message("Cancel")),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                }),
            CupertinoDialogAction(
              child: Text(Intl.message("Continue")),
              onPressed: () {
                onConfirm();
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> buildOptionList(BuildContext context) {
    List<Widget> list = [];

    /* Delete post feature */
    if (this.widget.arguments.post != null &&
        !this.widget.arguments.post.isDeleted &&
        (isMeDiscussionModerator() || isMePostAuthor())) {
      list.add(
        SuperpowersPopupOption(
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
          onTap: () => showConfirmationDialog(
            context,
            () {
              BlocProvider.of<SuperpowersBloc>(context).add(
                DeletePostEvent(
                  discussion: this.widget.arguments.discussion,
                  post: this.widget.arguments.post,
                ),
              );
              return true;
            },
          ),
        ),
      );
    }

    /* Ban participant feature */
    if (this.widget.arguments.participant != null &&
        isMeDiscussionModerator() &&
        !isParticipantModerator()) {
      list.add(
        SuperpowersPopupOption(
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
              "Ban the selected participant from the discussion and delete every post they authored."),
          onTap: () => showConfirmationDialog(
            context,
            () {
              BlocProvider.of<SuperpowersBloc>(context).add(
                BanParticipantEvent(
                  discussion: this.widget.arguments.discussion,
                  participant: this.widget.arguments.participant,
                ),
              );
              return true;
            },
          ),
        ),
      );
    }

    /* Mute participant feature */
    if (this.widget.arguments.participant != null &&
        !this.widget.arguments.participant.isMuted &&
        isMeDiscussionModerator() &&
        !isParticipantModerator()) {
      list.add(
        SuperpowersPopupOption(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SpacingValues.medium),
                color: Colors.black),
            clipBehavior: Clip.antiAlias,
            child: Icon(Icons.volume_off, size: 36),
          ),
          title: Intl.message("Mute Participant"),
          description: Intl.message(
              "Mute the selected participant so that they are will not be able to post in this discussion for a while."),
          onTap: () => showMuteConfirmationDialog(
            context,
            (hours) {
              BlocProvider.of<SuperpowersBloc>(context).add(
                MuteParticipantEvent(
                  discussion: this.widget.arguments.discussion,
                  participants: [this.widget.arguments.participant],
                  muteForSeconds: Duration(hours: hours).inSeconds,
                ),
              );
              return true;
            },
          ),
        ),
      );
    }

    /* Unmute participant feature */
    if (this.widget.arguments.participant != null &&
        this.widget.arguments.participant.isMuted &&
        isMeDiscussionModerator() &&
        !isParticipantModerator()) {
      list.add(
        SuperpowersPopupOption(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SpacingValues.medium),
                color: Colors.black),
            clipBehavior: Clip.antiAlias,
            child: Icon(Icons.volume_up, size: 36),
          ),
          title: Intl.message("Unmute Participant"),
          description: Intl.message(
              "Unmute the selected participant and allow them to post in this discussion again."),
          onTap: () {
            BlocProvider.of<SuperpowersBloc>(context).add(
              UnmuteParticipantEvent(
                discussion: this.widget.arguments.discussion,
                participants: [this.widget.arguments.participant],
              ),
            );
          },
        ),
      );
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

  bool isParticipantModerator() {
    return this.widget.arguments.participant?.userProfile?.id ==
            this.widget.arguments.discussion?.moderator?.userProfile?.id ??
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
