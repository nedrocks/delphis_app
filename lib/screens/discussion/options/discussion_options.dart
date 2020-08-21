import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/superpowers/superpowers_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class DiscussionOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(22, 23, 28, 1.0),
      body: Container(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.all(SpacingValues.medium),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: SpacingValues.medium),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Material(
                        color: Colors.transparent,
                        type: MaterialType.circle,
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.all(SpacingValues.medium),
                              child: SvgPicture.asset(
                                'assets/svg/back_chevron.svg',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: SpacingValues.smallMedium,
                      ),
                      Text(
                        Intl.message("Options"),
                        style: TextThemes.participantListScreenTitle,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SpacingValues.small,
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
                        final optionList = List<Widget>();
                        optionList.add(SuperpowersOption(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(SpacingValues.medium),
                              color: Colors.black,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Icon(Icons.info, size: 36),
                          ),
                          title: Intl.message("Info"),
                          description: Intl.message("Show chat information"),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/Discussion/Info',
                            );
                          },
                        ));
                        optionList.add(
                          SuperpowersOption(
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(SpacingValues.medium),
                                color: Colors.black,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Icon(Icons.person, size: 36),
                            ),
                            title: Intl.message("Participants"),
                            description:
                                Intl.message("Show the participant list"),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/Discussion/ParticipantList',
                              );
                            },
                          ),
                        );
                        if (state.discussion.isActive) {
                          final isMuted = state.discussion.isMuted;
                          optionList.add(
                            SuperpowersOption(
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      SpacingValues.medium),
                                  color: Colors.black,
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: isMuted
                                    ? Icon(Icons.volume_up, size: 36)
                                    : Icon(Icons.volume_mute, size: 36),
                              ),
                              title: isMuted
                                  ? Intl.message("Unmute Discussion")
                                  : Intl.message("Mute Discussion"),
                              description: isMuted
                                  ? Intl.message(
                                      'Unmute notifications for this discussion')
                                  : Intl.message(
                                      "Mute notifications for this discussion"),
                              onTap: () {
                                BlocProvider.of<DiscussionBloc>(context).add(
                                    DiscussionMuteEvent(
                                        discussionID: state.discussion.id,
                                        isMute: !isMuted));
                              },
                            ),
                          );
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: optionList,
                            ),
                          ),
                        );
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
