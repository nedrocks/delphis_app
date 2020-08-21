import 'dart:ui';

import 'package:delphis_app/bloc/superpowers/superpowers_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/superpowers/superpowers_option.dart';
import 'package:delphis_app/screens/superpowers/superpowers_arguments.dart';
import 'package:delphis_app/screens/upsert_discussion/screen_arguments.dart';
import 'package:delphis_app/screens/upsert_discussion/upsert_discussion_screen.dart';
import 'package:delphis_app/widgets/animated_size_container/animated_size_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class SuperpowersScreen extends StatefulWidget {
  final SuperpowersArguments arguments;

  const SuperpowersScreen({
    Key key,
    @required this.arguments,
  }) : super(key: key);

  @override
  _SuperpowersScreenState createState() => _SuperpowersScreenState();
}

class _SuperpowersScreenState extends State<SuperpowersScreen> {
  Widget panelToShow;
  OverlayEntry lastOverlayEntry;

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
            this.onCancel(context);
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
          var options = buildOptionList(context);
          toRender = Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: SpacingValues.extraLarge),
                Text(
                  isMeDiscussionModerator()
                      ? Intl.message("Moderator Superpowers")
                      : Intl.message("User Options"),
                  style: TextThemes.goIncognitoHeader,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SpacingValues.medium),
                Container(
                    height: 1.0, color: Color.fromRGBO(110, 111, 121, 0.6)),
                SizedBox(height: SpacingValues.small),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SpacingValues.medium,
                        vertical: SpacingValues.small),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        return options[index];
                      },
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
                    this.onCancel(context);
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
          body: SafeArea(
            child: Container(
              color: Color.fromRGBO(22, 23, 28, 1.0),
              child: toRender,
            ),
          ),
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

    /* Copy inviting link to clipboard */
    if (isMeDiscussionModerator()) {
      list.add(
        SuperpowersOption(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SpacingValues.medium),
                color: Colors.black),
            clipBehavior: Clip.antiAlias,
            child: Icon(Icons.person_add, size: 36),
          ),
          title: Intl.message("Copy Link"),
          description: Intl.message(
              "Create an invitation link and copy it to the clipboard so that you can share it with other people."),
          onTap: () {
            BlocProvider.of<SuperpowersBloc>(context).add(
              CopyDiscussionLinkEvent(
                discussion: this.widget.arguments.discussion,
                isVip: false,
              ),
            );
          },
        ),
      );
    }

    /* Modify discussion's title and description */
    if (isMeDiscussionModerator()) {
      list.add(SuperpowersOption(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SpacingValues.medium),
                  color: Colors.black),
              clipBehavior: Clip.antiAlias,
              child: Container(
                margin: EdgeInsets.all(21),
                child: SvgPicture.asset(
                  'assets/svg/chat-icon.svg',
                  width: 36,
                  color: Colors.white,
                ),
              )),
          title: Intl.message("Title and Description"),
          description: Intl.message(
              "Manage the preferences of this discussion. View and modify the title and description."),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/Discussion/Upsert',
              arguments: UpsertDiscussionArguments(
                discussion: this.widget.arguments.discussion,
                firstPage: UpsertDiscussionScreenPage.TITLE_DESCRIPTION,
                isUpdateMode: true,
              ),
            );
          }));
    }

    /* Modify discussion's invite mode */
    if (isMeDiscussionModerator()) {
      list.add(SuperpowersOption(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SpacingValues.medium),
                  color: Colors.black),
              clipBehavior: Clip.antiAlias,
              child: Container(
                margin: EdgeInsets.all(24),
                child: SvgPicture.asset(
                  'assets/svg/paper_airplane.svg',
                  width: 32,
                  color: Colors.white,
                ),
              )),
          title: Intl.message("Joinability"),
          description: Intl.message(
              "Manage the preferences of this discussion. Choose how you prefer to manage the joinability."),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/Discussion/Upsert',
              arguments: UpsertDiscussionArguments(
                discussion: this.widget.arguments.discussion,
                firstPage: UpsertDiscussionScreenPage.INVITATION_MODE,
                isUpdateMode: true,
              ),
            );
          }));
    }

    if (isMeDiscussionModerator()) {
      list.add(SuperpowersOption(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SpacingValues.medium),
                  color: Colors.black),
              clipBehavior: Clip.antiAlias,
              child: Container(
                child: Icon(
                  Icons.assignment,
                  size: 36,
                  color: Colors.white,
                ),
              )),
          title: Intl.message("Access Requests"),
          description: Intl.message(
              "Manage users that requested access to this chat. View all the pending requests and accept or reject them."),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/Discussion/AccessRequestList',
            );
          }));
    }

    // /* Invite user from Twitter handle */
    // if (isMeDiscussionModerator()) {
    //   list.add(ModeratorPopupOption(
    //       child: Container(
    //         width: double.infinity,
    //         height: double.infinity,
    //         decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(SpacingValues.medium),
    //             color: Colors.black),
    //         clipBehavior: Clip.antiAlias,
    //         child: Container(
    //           margin: EdgeInsets.all(28),
    //           child: SvgPicture.asset(
    //             'assets/svg/twitter_logo.svg',
    //             color: ChathamColors.twitterLogoColor,
    //           ),
    //         ),
    //       ),
    //       title: Intl.message("Twitter Invitation"),
    //       description:
    //           Intl.message("Invite new users searching them on Twitter."),
    //       onTap: () {
    //         setState(() {
    //           this.panelToShow = BlocProvider<TwitterInvitationBloc>(
    //             create: (context) => TwitterInvitationBloc(
    //               repository: RepositoryProvider.of<UserRepository>(context),
    //               twitterUserRepository:
    //                   RepositoryProvider.of<TwitterUserRepository>(context),
    //             ),
    //             child: TwitterInvitationForm(
    //               participant: this.widget.arguments?.discussion?.meParticipant,
    //               discussion: this.widget.arguments?.discussion,
    //               onCancel: this.cancelPanelToShow,
    //             ),
    //           );
    //           BlocProvider.of<SuperpowersBloc>(context).add(ResetEvent());
    //         });
    //       }));
    // }

    /* A user could have no actions avaliable */
    if (list.length == 0) {
      list.add(Container(
        height: 80,
        child: Center(
          child: Text(
            Intl.message("There are no actions available."),
            style: TextThemes.goIncognitoOptionName,
          ),
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

  void onCancel(BuildContext context) {
    Navigator.of(context).pop();
  }
}
