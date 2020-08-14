import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/discussion/discussion_history_arguments.dart';
import 'package:delphis_app/screens/discussion/history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DiscussionInfo extends StatelessWidget {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      Intl.message("Info"),
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
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: SpacingValues.large),
                              Row(
                                children: [
                                  Text(
                                    state.discussion.title,
                                    style: TextThemes.chatInfoListTitle,
                                  ),
                                  SizedBox(width: SpacingValues.extraLarge),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          '/Discussion/HistoryView',
                                          arguments:
                                              DiscussionHistoryViewArguments(
                                                  viewType:
                                                      DiscussionHistoryViewType
                                                          .TITLE));
                                    },
                                    child: Icon(Icons.schedule, size: 24),
                                  )
                                ],
                              ),
                              state.discussion.description != null &&
                                      state.discussion.description.length > 0
                                  ? Row(children: [
                                      Text(
                                        state.discussion.description,
                                        style:
                                            TextThemes.chatInfoListDescription,
                                      ),
                                      SizedBox(width: SpacingValues.extraLarge),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              '/Discussion/HistoryView',
                                              arguments:
                                                  DiscussionHistoryViewArguments(
                                                      viewType:
                                                          DiscussionHistoryViewType
                                                              .DESCRIPTION));
                                        },
                                        child: Icon(Icons.schedule, size: 24),
                                      )
                                    ])
                                  : Container(),
                              SizedBox(height: SpacingValues.large),
                              Text(
                                  'Total Participants: ${state.discussion.participants.length}',
                                  style: TextThemes.chatInfoListParticipants),
                            ]);
                      }
                      return Container();
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
