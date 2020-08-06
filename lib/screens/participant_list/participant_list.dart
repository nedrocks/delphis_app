import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/participant_list/participant_snippet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ParticipantListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(22, 23, 28, 1.0),
              borderRadius: BorderRadius.circular(40),
            ),
            margin: EdgeInsets.all(SpacingValues.large),
            padding: EdgeInsets.all(SpacingValues.xxLarge),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      Intl.message("Participants"),
                      style: TextThemes.participantListScreenTitle,
                    ),
                    Material(
                      color: Colors.white,
                      type: MaterialType.circle,
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        padding: EdgeInsets.all(SpacingValues.extraSmall),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: SpacingValues.mediumLarge,
                ),
                Expanded(
                  child: BlocBuilder<DiscussionBloc, DiscussionState>(
                    builder: (context, state) {
                      if (state is DiscussionLoadingState) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is DiscussionLoadedState) {
                        var moderator = state.discussion.moderator;
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: state.discussion.participants.length,
                          itemBuilder: (context, index) {
                            var participant =
                                state.discussion.participants[index];
                            var isModerator = participant.userProfile.id ==
                                moderator.userProfile.id;
                            print("$index $isModerator");
                            return ParticipantSnippet(
                              height: 50,
                              moderator: moderator,
                              participant: participant,
                              showOptions:
                                  state.discussion.isMeDiscussionModerator() &&
                                      !isModerator,
                              onOptionsTap: () {
                                // TODO: Navigate to superpowers panel
                              },
                            );
                          },
                        );
                      }
                      return Center(
                        child: Text(
                          Intl.message(
                              "Looks like there are no participants in this chat."),
                          style: TextThemes.onboardBody,
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
