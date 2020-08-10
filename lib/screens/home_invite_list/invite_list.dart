import 'package:delphis_app/bloc/discussion_list/discussion_list_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/discussion/screen_args/discussion.dart';
import 'package:delphis_app/screens/home_invite_list/invite_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class InviteListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscussionListBloc, DiscussionListState>(
      builder: (context, state) {
        if (!(state is DiscussionListLoaded)) {
          return SizedBox(height: 0);
        }
        var pendingDiscussions =
            state.activeDiscussions.where((d) => d.isPendingAccess).toList();

        if (pendingDiscussions.length > 0) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: pendingDiscussions.length,
            itemBuilder: (context, index) {
              return InviteEntry(
                discussion: pendingDiscussions[index],
                onPressed: (discussion) {
                  Navigator.of(context).pushNamed(
                    '/Discussion',
                    arguments: DiscussionArguments(discussionID: discussion.id),
                  );
                },
                onArchivePressed: (discussion) {
                  BlocProvider.of<DiscussionListBloc>(context).add(
                    DiscussionListArchiveEvent(discussion),
                  );
                },
              );
            },
          );
        }

        return Container(
          margin: EdgeInsets.all(SpacingValues.xxLarge),
          child: Center(
            child: Text(
              Intl.message(
                  "Looks like you haven’t been invited to any discussions."),
              textAlign: TextAlign.center,
              style: TextThemes.onboardBody,
            ),
          ),
        );
      },
    );
  }
}
