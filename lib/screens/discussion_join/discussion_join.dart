import 'dart:ui';

import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/bloc/me/me_bloc.dart';
import 'package:delphis_app/bloc/participant/participant_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/discussion_join/join_content.dart';
import 'package:delphis_app/screens/discussion_join/moderator_snippet.dart';
import 'package:delphis_app/widgets/discussion_header/participant_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DiscussionJoinScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: new ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Container(
            child: SafeArea(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(22, 23, 28, 1.0),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  margin: EdgeInsets.all(SpacingValues.xxLarge),
                  padding: EdgeInsets.all(SpacingValues.xxLarge),
                  child: BlocBuilder<DiscussionBloc, DiscussionState>(
                      builder: (context, state) {
                    if (state is DiscussionLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is DiscussionLoadedState) {
                      final discussion = state.getDiscussion();
                      final moderator = discussion.moderator;
                      final joinResponse =
                          discussion.meCanJoinDiscussion.response;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  Intl.message(discussion.title),
                                  style: TextThemes.discussionJoinScreenTitle,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              (discussion.description?.length ?? 0) == 0
                                  ? Container()
                                  : Flexible(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          top: SpacingValues.small,
                                        ),
                                        child: Text(
                                          discussion.title,
                                          style: TextThemes
                                              .discussionJoinScreenSubtitle,
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                              SizedBox(height: SpacingValues.large),
                              ModeratorSnippet(moderator: moderator),
                              SizedBox(height: SpacingValues.medium),
                              (discussion.participants?.length ?? 0) > 0
                                  ? Row(
                                      children: <Widget>[
                                        ParticipantImages(
                                          height: 32,
                                          maxNonAnonToShow: 3,
                                          participants: discussion.participants,
                                          moderator: moderator,
                                        ),
                                        SizedBox(width: SpacingValues.medium),
                                        Flexible(
                                          child: Text(
                                            Intl.message(
                                                "${discussion.participants.length} others are participating"),
                                            style:
                                                TextThemes.discussionPostText,
                                            textAlign: TextAlign.left,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Flexible(
                                      child: Text(
                                        Intl.message("Nobody has joined yet"),
                                        style: TextThemes.discussionPostText,
                                        textAlign: TextAlign.left,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                              SizedBox(height: SpacingValues.large),
                              BlocBuilder<MeBloc, MeState>(
                                builder: (context, state) {
                                  if (state is LoadedMeState) {
                                    var user = MeBloc.extractMe(state);
                                    return JoinContent(
                                      joinability: joinResponse,
                                      onBackPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      onAccessRequestPressed: () {
                                        // TODO: Send access request
                                      },
                                      onJoinPressed: () {
                                        // TODO: Call join mutation
                                      },
                                    );
                                  }
                                  return CircularProgressIndicator();
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    return Container();
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
