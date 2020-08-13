import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/data/repository/discussion_access.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/access_request_list/access_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class AccessRequestListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color.fromRGBO(22, 23, 28, 1.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(22, 23, 28, 1.0),
              borderRadius: BorderRadius.circular(40),
            ),
            margin: EdgeInsets.symmetric(
              vertical: SpacingValues.large,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      type: MaterialType.circle,
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SpacingValues.large,
                            vertical: SpacingValues.medium,
                          ),
                          child: SvgPicture.asset(
                            'assets/svg/back_chevron.svg',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SpacingValues.medium,
                    ),
                    Text(
                      Intl.message("Access Requests"),
                      style: TextThemes.participantListScreenTitle,
                    ),
                  ],
                ),
                SizedBox(
                  height: SpacingValues.mediumLarge,
                ),
                Expanded(
                  child: BlocBuilder<DiscussionBloc, DiscussionState>(
                    builder: (context, state) {
                      var discussion = state.getDiscussion();
                      if (state is DiscussionLoadingState) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is DiscussionLoadedState) {
                        final requestCount =
                            discussion.accessRequests?.length ?? 0;
                        final slidableController = SlidableController();
                        if (requestCount > 0) {
                          return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: requestCount,
                            itemBuilder: (context, index) {
                              var request = discussion.accessRequests[index];
                              return AccessRequestEntry(
                                slidableController: slidableController,
                                accessRequest: request,
                                onAccept: () {
                                  BlocProvider.of<DiscussionBloc>(context).add(
                                    DiscussionRespondToAccessRequestEvent(
                                      requestID: request.id,
                                      status: InviteRequestStatus.ACCEPTED,
                                    ),
                                  );
                                },
                                onReject: () {
                                  BlocProvider.of<DiscussionBloc>(context).add(
                                    DiscussionRespondToAccessRequestEvent(
                                      requestID: request.id,
                                      status: InviteRequestStatus.REJECTED,
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                      }
                      return Center(
                        child: Text(
                          Intl.message(
                              "Looks like you have no pending access requests for this chat."),
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
