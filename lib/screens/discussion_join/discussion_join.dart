import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DiscussionJoinScreen extends StatelessWidget {
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
            margin: EdgeInsets.all(SpacingValues.medium),
            padding: EdgeInsets.all(SpacingValues.xxLarge),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      Intl.message("Join Discussion"),
                      style: TextThemes.discussionJoinScreenTitle,
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
                        return Container();
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
