import 'package:delphis_app/bloc/me/me_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/pending_requests_list/requests_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RequestsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeBloc, MeState>(
      builder: (context, meState) {
        final currentUser = MeBloc.extractMe(meState);
        if (currentUser != null) {
          final accessRequests = currentUser.pendingSentAccessRequests;
          if (accessRequests.length > 0) {
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: accessRequests.length,
              itemBuilder: (context, index) {
                return RequestsListEntry(
                  request: accessRequests[index],
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
