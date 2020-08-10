import 'package:delphis_app/bloc/me/me_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/home_invite_list/invite_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class InviteListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeBloc, MeState>(
      builder: (context, meState) {
        final currentUser = MeBloc.extractMe(meState);
        if (currentUser != null) {
          var invites = currentUser.pendingDiscussionInvites;
          if (invites.length > 0) {
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: invites.length,
              itemBuilder: (context, index) {
                return InviteEntry(
                  invite: invites[index],
                );
              },
            );
          }
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
