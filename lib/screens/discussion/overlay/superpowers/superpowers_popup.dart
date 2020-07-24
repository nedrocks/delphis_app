
import 'dart:ui';

import 'package:delphis_app/bloc/superpowers/superpowers_bloc.dart';
import 'package:delphis_app/data/repository/twitter_user.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/discussion/overlay/overlay_alert_dialog.dart';
import 'package:delphis_app/screens/discussion/overlay/superpowers/invite_twitter_user_popup.dart';
import 'package:delphis_app/screens/discussion/overlay/superpowers/superpowers_popup_option.dart';
import 'package:delphis_app/screens/discussion/screen_args/superpowers_arguments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class SuperpowersPopup extends StatefulWidget {
  final SuperpowersArguments arguments;
  final VoidCallback onCancel;
  
  const SuperpowersPopup({
    Key key, 
    @required this.arguments,
    @required this.onCancel
  }) : super(key: key);


  @override
  _SuperpowersPopupState createState() => _SuperpowersPopupState();
}

class _SuperpowersPopupState extends State<SuperpowersPopup> {
  Widget panelToShow;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuperpowersBloc, SuperpowersState> (
      builder: (context, state) {
        
        /* Format error messages */
        Widget bottomWidget = Container();
        if(state is ErrorState) {
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
        if(state is SuccessState) {
          /* Dismiss the popup if the result is successful */
          SchedulerBinding.instance.addPostFrameCallback((_) {
            this.widget.onCancel();
          });
        }

        /* Format loading status */
        if(state is LoadingState) {
          bottomWidget = Column(
            children: [
              CupertinoActivityIndicator(),
              SizedBox(height: SpacingValues.medium),
            ],
          );
        }

        var toRender;
        if(panelToShow != null) {
          toRender = panelToShow;
        }
        else {
          toRender = Container(
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
              Container(height: 1.0, color: Color.fromRGBO(110, 111, 121, 0.6)),
              SizedBox(height: SpacingValues.small),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                  child: Row(
                    children: buildOptionList(context),
                  ),
                ),
              SizedBox(height: SpacingValues.small),
              bottomWidget,
              Container(height: 1.0, color: Color.fromRGBO(110, 111, 121, 0.6)),
              GestureDetector(
                onTap: () {
                  this.widget.onCancel();
                },
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: SpacingValues.xxLarge, vertical: SpacingValues.mediumLarge),
                  child: Text(
                    Intl.message('Close'),
                    style: TextThemes.backButton,
                  )
                )
              ),
            ]
          )
        );
        }

        /* Render popup */
        return SafeArea(
          child: Card(
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            elevation: 50.0,
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.only(
                left: SpacingValues.extraLarge,
                right: SpacingValues.extraLarge,
                top: SpacingValues.mediumLarge),
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromRGBO(34, 35, 40, 1.0), width: 1.5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36.0),
                  topRight: Radius.circular(36.0)),
                  color: Color.fromRGBO(22, 23, 28, 1.0)
              ),
              child: toRender
            )
          )
        );
      },
    );
  }

  /* This is overlay-safe */
  void showConfirmationDialog(BuildContext context, VoidCallback onConfirm) {
    OverlayEntry overlayEntry;
    overlayEntry = OverlayAlertDialog(
      title: Container(
        margin: EdgeInsets.only(bottom: SpacingValues.smallMedium),
        child: Text(
          Intl.message("Are you sure?"),
          style: TextThemes.goIncognitoHeader
        ),
      ),
      content: Text(
        "This action will have irreversible effects, do you still desire to proceed?",
        style: TextThemes.goIncognitoOptionName.copyWith(height: 1.25),
      ),
      actions: [
        CupertinoDialogAction(
          child: Text(Intl.message("Cancel")),
          onPressed: () => overlayEntry?.remove()
        ),
        CupertinoDialogAction(
          child: Text(Intl.message("Continue")),
          onPressed: () {
            overlayEntry?.remove();
            onConfirm();
          },
        )
      ],
    );
    Overlay.of(context).insert(
      overlayEntry
    );
  }

  List<Widget> buildOptionList(BuildContext context) {
    List<Widget> list = [];

    /* Delete post feature */
    if(this.widget.arguments.post != null && !this.widget.arguments.post.isDeleted && (isMeDiscussionModerator() || isMePostAuthor())) { 
      list.add(ModeratorPopupOption(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SpacingValues.medium),
            color: Colors.black
          ),
          clipBehavior: Clip.antiAlias,
          child: Icon(Icons.delete_forever, size: 50),
        ),
        title: Intl.message("Delete post"),
        description: Intl.message("Remove this post from the discussion."),
        onTap: () => showConfirmationDialog(context, () {
          BlocProvider.of<SuperpowersBloc>(context).add(DeletePostEvent(
            discussion: this.widget.arguments.discussion,
            post: this.widget.arguments.post
          ));
          return true;
        }),
      ));
    }

    /* Ban participant feature */
    if(this.widget.arguments.participant != null && this.widget.arguments.post != null && isMeDiscussionModerator() && !isMePostAuthor()) { 
      list.add(ModeratorPopupOption(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SpacingValues.medium),
            color: Colors.black
          ),
          clipBehavior: Clip.antiAlias,
          child: Icon(Icons.block, size: 50),
        ),
        title: Intl.message("Kick participant"),
        description: Intl.message("Ban the author of this post from the discussion."),
        onTap: () => showConfirmationDialog(context, () {
          BlocProvider.of<SuperpowersBloc>(context).add(
            BanParticipantEvent(
              discussion: this.widget.arguments.discussion,
              participant: this.widget.arguments.post.participant
            )
          );
          return true;
        })
      ));
    }

    /* Copy inviting link to clipboard */
    if(isMeDiscussionModerator()) { 
      list.add(ModeratorPopupOption(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SpacingValues.medium),
            color: Colors.black
          ),
          clipBehavior: Clip.antiAlias,
          child: Icon(Icons.person_add, size: 45),
        ),
        title: Intl.message("Copy Link"),
        description: Intl.message("Create an invitation link and copy it to the clipboard."),
        onTap: () {
          BlocProvider.of<SuperpowersBloc>(context).add(
            CopyDiscussionLinkEvent(
              discussion: this.widget.arguments.discussion,
              isVip: false
            )
          );
        }
      ));
    }

    /* Copy vip inviting link to clipboard */
    if(isMeDiscussionModerator()) { 
      list.add(ModeratorPopupOption(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SpacingValues.medium),
            color: Colors.black
          ),
          clipBehavior: Clip.antiAlias,
          child: Icon(Icons.star_border, size: 50),
        ),
        title: Intl.message("Copy VIP Link"),
        description: Intl.message("Copy a VIP invitation link to the clipboard."),
        onTap: () {
          BlocProvider.of<SuperpowersBloc>(context).add(
            CopyDiscussionLinkEvent(
              discussion: this.widget.arguments.discussion,
              isVip: true
            )
          );
        }
      ));
    }

    /* Invite user from Twitter handle */
    if(isMeDiscussionModerator()) {
      list.add(ModeratorPopupOption(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SpacingValues.medium),
            color: Colors.black
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            margin: EdgeInsets.all(28),
            child: SvgPicture.asset('assets/svg/twitter_logo.svg',
              color: ChathamColors.twitterLogoColor,
            ),
          ),
        ),
        title: Intl.message("Twitter Invitation"),
        description: Intl.message("Invite new users searching them on Twitter."),
        onTap: () {
          setState(() {
            this.panelToShow = InviteTwitterUserPopup(
              onCancel: this.cancelPanelToShow,
              onSubmit: (twitterHandle) {
                this.cancelPanelToShow();
                BlocProvider.of<SuperpowersBloc>(context).add(
                  InviteTwitterUserEvent(
                    input: TwitterUserInput(
                      name: twitterHandle
                    )
                  )
                );
              },
            );
          });
        }
      ));
    }

    /* A user could have no actions avaliable */
    if(list.length == 0) {
      list.add(Container(
        height: 80,
        child: Center(
          child: Text(
            Intl.message("There are no actions available."),
            style: TextThemes.goIncognitoOptionName
          ),
        ),
      ));
    }

    return list;
  }

  bool isMeDiscussionModerator() {
    return this.widget.arguments?.discussion?.isMeDiscussionModerator() ?? false;
  }

  bool isMePostAuthor() {
    return this.widget.arguments.post != null && (this.widget.arguments.discussion?.meAvailableParticipants
        ?.where((e) => e.discussion.id == this.widget.arguments.discussion.id)
        ?.map((e) => e.participantID)
        ?.contains(this.widget.arguments.post.participant?.participantID) ?? false);
  }

  void cancelPanelToShow() {
    setState(() {
      this.panelToShow = null;
    });
    BlocProvider.of<SuperpowersBloc>(context).add(ResetEvent());
  }

}