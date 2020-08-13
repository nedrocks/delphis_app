import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

enum DiscussionHistoryViewType { TITLE, DESCRIPTION }

class DiscussionHistoryView extends StatelessWidget {
  final DiscussionHistoryViewType historyType;

  const DiscussionHistoryView({
    @required this.historyType,
  });

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
                      Intl.message("History"),
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
                        final header =
                            historyType == DiscussionHistoryViewType.TITLE
                                ? 'Title'
                                : 'Description';
                        final historyObj =
                            historyType == DiscussionHistoryViewType.TITLE
                                ? state.discussion.titleHistory
                                : state.discussion.descriptionHistory;
                        if (historyObj == null) {
                          return Container();
                        }
                        return Column(
                          children: [
                            Container(
                                height: 30.0,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(Intl.message(header),
                                          style: TextThemes.historyTitle),
                                    ),
                                    Text(Intl.message('Created'),
                                        style: TextThemes.historyTitle),
                                  ],
                                )),
                            Expanded(
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: historyObj.length,
                                  itemBuilder: (context, index) {
                                    final historicalString =
                                        historyObj.elementAt(index);
                                    final createdAt = DateTime.parse(
                                        historicalString.createdAt);
                                    return Container(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: Text(
                                                  historicalString.value,
                                                  style: TextThemes
                                                      .historyContent)),
                                          SizedBox(width: SpacingValues.small),
                                          Text(
                                              DateFormat('yyyy-MM-dd')
                                                  .format(createdAt),
                                              style: TextThemes.historyContent),
                                        ],
                                      ),
                                    );
                                  }),
                            )
                          ],
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
