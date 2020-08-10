import 'package:delphis_app/bloc/upsert_chat/upsert_discussion_bloc.dart';
import 'package:delphis_app/bloc/upsert_chat/upsert_discussion_info.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/upsert_discussion/pages/base_page_widget.dart';
import 'package:delphis_app/screens/upsert_discussion/widgets/check_list_option.dart';
import 'package:delphis_app/widgets/animated_size_container/animated_size_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class InviteModePage extends StatefulWidget {
  static final allowTwitterFriendsText = Intl.message(
      "Automatically allow everyone I'm following on Twitter to join, but I will manually approve everyone else");
  static final allRequireApprovalText =
      Intl.message("I will manually approve all requests to join");
  final String nextButtonText;
  final String prevButtonText;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final bool isUpdateMode;

  const InviteModePage({
    Key key,
    @required this.nextButtonText,
    @required this.prevButtonText,
    @required this.onBack,
    @required this.onNext,
    @required this.isUpdateMode,
  }) : super(key: key);

  @override
  _InviteModePageState createState() => _InviteModePageState();
}

class _InviteModePageState extends State<InviteModePage> {
  var error;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<UpsertDiscussionBloc, UpsertDiscussionState>(
      builder: (context, state) {
        Widget nextButton = Text(
          this.widget.nextButtonText,
          style: TextThemes.joinButtonTextChatTab,
        );
        if (!this.widget.isUpdateMode) {
          nextButton = Row(
            children: <Widget>[
              Icon(Icons.add, color: Colors.black),
              SizedBox(width: SpacingValues.extraSmall),
              nextButton,
            ],
          );
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            color: Colors.black,
            child: BasePageWidget(
              title: "Invitation Mode",
              nextButtonChild: nextButton,
              backButtonChild: Text(this.widget.prevButtonText),
              onBack: this.widget.onBack,
              onNext: state.info.inviteMode == null
                  ? null
                  : () => this.onNext(context, state.info),
              nextColor: state.info.inviteMode == null
                  ? Color.fromRGBO(247, 247, 255, 0.5)
                  : Color.fromRGBO(247, 247, 255, 1.0),
              contents: Container(
                margin: EdgeInsets.all(SpacingValues.extraLarge),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        Intl.message(
                            'Who would you like to have access to your discussion?'),
                        style: TextThemes.onboardHeading,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: SpacingValues.smallMedium,
                      ),
                      Text(
                        Intl.message(
                            'Choose how you prefer to manage invitations for this discussion.'),
                        style: TextThemes.onboardBody,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: SpacingValues.large,
                      ),
                      Container(
                        child: SvgPicture.asset(
                          'assets/svg/paper_airplane.svg',
                          width: 50,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: SpacingValues.xxLarge,
                      ),
                      AnimatedSizeContainer(
                        builder: (context) {
                          if (error != null) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: SpacingValues.medium),
                                  child: Text(
                                    error.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextThemes.discussionPostText
                                        .copyWith(color: Colors.red),
                                  ),
                                ),
                                SizedBox(
                                  height: SpacingValues.medium,
                                ),
                              ],
                            );
                          }
                          return Container();
                        },
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CheckListOption(
                            isSelected: state.info.inviteMode ==
                                DiscussionJoinabilitySetting
                                    .ALLOW_TWITTER_FRIENDS,
                            text: InviteModePage.allowTwitterFriendsText,
                            onTap: () =>
                                BlocProvider.of<UpsertDiscussionBloc>(context)
                                    .add(
                              UpsertDiscussionSetInviteModeEvent(
                                  inviteMode: DiscussionJoinabilitySetting
                                      .ALLOW_TWITTER_FRIENDS),
                            ),
                          ),
                          SizedBox(
                            height: SpacingValues.mediumLarge,
                          ),
                          CheckListOption(
                            isSelected: state.info.inviteMode ==
                                DiscussionJoinabilitySetting
                                    .ALL_REQUIRE_APPROVAL,
                            text: InviteModePage.allRequireApprovalText,
                            onTap: () =>
                                BlocProvider.of<UpsertDiscussionBloc>(context)
                                    .add(
                              UpsertDiscussionSetInviteModeEvent(
                                  inviteMode: DiscussionJoinabilitySetting
                                      .ALL_REQUIRE_APPROVAL),
                            ),
                          ),
                        ],
                      ),
                      BlocBuilder<UpsertDiscussionBloc, UpsertDiscussionState>(
                        builder: (context, state) {
                          if (state is UpsertDiscussionLoadingState) {
                            return Container(
                              margin:
                                  EdgeInsets.only(top: SpacingValues.medium),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          if (state is UpsertDiscussionErrorState) {
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: SpacingValues.medium),
                                  child: Text(
                                    state.error.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextThemes.discussionPostText
                                        .copyWith(color: Colors.red),
                                  ),
                                ),
                                SizedBox(
                                  height: SpacingValues.medium,
                                ),
                              ],
                            );
                          }
                          return Container();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onNext(BuildContext context, UpsertDiscussionInfo info) {
    setState(() {
      this.error = null;
      if (info.inviteMode == null) {
        error = Intl.message("You need to specify a preferred option.");
      } else if (this.widget.onNext != null) {
        this.widget.onNext();
      }
    });
  }
}
