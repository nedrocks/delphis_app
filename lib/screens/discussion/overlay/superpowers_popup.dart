
import 'dart:ui';

import 'package:delphis_app/bloc/superpowers/superpowers_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/discussion/overlay/superpowers_popup_option.dart';
import 'package:delphis_app/screens/discussion/screen_args/moderator_popup_arguments.dart';
import 'package:delphis_app/util/display_names.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SuperpowersPopup extends StatelessWidget {
  final ModeratorPopupArguments arguments;
  final VoidCallback onCancel;
  
  const SuperpowersPopup({
    Key key, 
    @required this.arguments,
    @required this.onCancel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuperpowersBloc, SuperpowersState>(
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
          bottomWidget = Column(
            children: [
              Text(
                state.message,
                style: TextThemes.goIncognitoButton.copyWith(color: Colors.green),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SpacingValues.medium),
            ],
          );

          /* Dismiss the popup if the result is successful */
          SchedulerBinding.instance.addPostFrameCallback((_) {
            this.onCancel();
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

        /* Render popup */
        return Card(
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
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Intl.message("Mod Superpowers"),
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
                  SizedBox(height: SpacingValues.mediumLarge),
                  GestureDetector(
                    onTap: () {
                      this.onCancel();
                    },
                    child: Text(
                      Intl.message('Cancel'),
                      style: TextThemes.cancelText,
                    )
                  ),
                  SizedBox(height: SpacingValues.mediumLarge),
                ]
              )
            ),
          )
        );
      },
    );
  }

  List<Widget> buildOptionList(BuildContext context) {
    List<Widget> list = [];
    if(arguments.selectedPost != null) {
      var authorName = DisplayNames.formatParticipant(arguments.selectedDiscussion.moderator, arguments.selectedPost.participant);
      list.add(ModeratorPopupOption(
        child: Image.asset("assets/images/app_icon/image.png"),
        title: Intl.message("Delete post"),
        description: Intl.message("Remove this post by $authorName from the discussion."),
        onTap: () {
          BlocProvider.of<SuperpowersBloc>(context).add(DeletePostEvent(
            discussion: this.arguments.selectedDiscussion,
            post: this.arguments.selectedPost
          ));
          return true;
        },
      ));
      list.add(ModeratorPopupOption(
        child: Image.asset("assets/images/app_icon/image.png"),
        title: Intl.message("Kick participant"),
        description: Intl.message("Ban $authorName from this discussion."),
        onTap: () {
          BlocProvider.of<SuperpowersBloc>(context).add(BanParticipantEvent(
            discussion: this.arguments.selectedDiscussion,
            participant: this.arguments.selectedPost.participant
          ));
          return true;
        },
      ));
    }
    return list;
  }
}