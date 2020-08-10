import 'package:delphis_app/bloc/discussion_list/discussion_list_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/notifiers/home_page_tab.dart';
import 'package:delphis_app/screens/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PendingInviteSnippet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomePageTabNotifier>(
      builder: (context, currentTab, _) {
        return BlocBuilder<DiscussionListBloc, DiscussionListState>(
          builder: (context, state) {
            if (currentTab.value != HomePageTab.ACTIVE) {
              return SizedBox(height: 0);
            }
            var pendingDiscussions = state.activeDiscussions
                .where((d) => d.isPendingAccess)
                .toList();
            var count = pendingDiscussions.length;

            /* Don't show if there are not invites */
            if (count == 0) {
              return SizedBox(height: 0);
            }

            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/Home/InviteList');
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SpacingValues.medium,
                    vertical: SpacingValues.mediumLarge),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(114, 30, 248, 1.0),
                    Color.fromRGBO(177, 79, 186, 1.0),
                  ]),
                ),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: SpacingValues.medium,
                      ),
                      Expanded(
                        child: Text(
                          count > 1
                              ? Intl.message(
                                  "You have $count pending invites...")
                              : Intl.message(
                                  "You have $count pending invite..."),
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/svg/forward_chevron.svg',
                        color: Colors.white,
                        height: 16.0,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
