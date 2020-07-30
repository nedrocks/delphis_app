import 'package:delphis_app/bloc/upsert_chat/upsert_discussion_bloc.dart';
import 'package:delphis_app/bloc/upsert_chat/upsert_discussion_info.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/upsert_discussion/pages/base_page_widget.dart';
import 'package:delphis_app/widgets/animated_size_container/animated_size_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class InviteModePage extends StatefulWidget {
  static final everyoneFollowedText = Intl.message(
      "Automatically allow everyone I’m following to join, but manually approve everyone else.");
  static final everyoneApprovedText =
      Intl.message("Manually approve all requests to join.");
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
          body: SingleChildScrollView(
            child: Container(
              color: Colors.black,
              height: height,
              child: BasePageWidget(
                title: "Invitation Mode",
                nextButtonChild: nextButton,
                backButtonChild: Text(this.widget.prevButtonText),
                onBack: this.widget.onBack,
                onNext: () => this.onNext(context, state.info),
                contents: Expanded(
                  child: Container(
                    margin: EdgeInsets.all(SpacingValues.extraLarge),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          Intl.message(
                              'There are many ways for you to decide who can participate in your new chat.'),
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
                          children: <Widget>[
                            _ModeOption(
                              isSelected: state.info.inviteMode ==
                                  DiscussionInviteMode.EVERYONE_FOLLOWED,
                              text: InviteModePage.everyoneFollowedText,
                              onTap: () =>
                                  BlocProvider.of<UpsertDiscussionBloc>(context)
                                      .add(
                                UpsertDiscussionSetInfoEvent(
                                    inviteMode:
                                        DiscussionInviteMode.EVERYONE_FOLLOWED),
                              ),
                            ),
                            SizedBox(
                              height: SpacingValues.mediumLarge,
                            ),
                            _ModeOption(
                              isSelected: state.info.inviteMode ==
                                  DiscussionInviteMode.EVERYONE_APPROVED,
                              text: InviteModePage.everyoneApprovedText,
                              onTap: () =>
                                  BlocProvider.of<UpsertDiscussionBloc>(context)
                                      .add(
                                UpsertDiscussionSetInfoEvent(
                                    inviteMode:
                                        DiscussionInviteMode.EVERYONE_APPROVED),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
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

class _ModeOption extends StatelessWidget {
  final bool isSelected;
  final String text;
  final VoidCallback onTap;

  const _ModeOption({Key key, this.isSelected, this.text, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final checkMarkSize = 24.0;
    final borderWidth = 2.0;
    Widget checkMark = Container(
      margin: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: borderWidth, color: Colors.white)),
      width: checkMarkSize - borderWidth * 2,
      height: checkMarkSize - borderWidth * 2,
    );
    if (this.isSelected) {
      checkMark =
          Icon(Icons.check_circle, color: Colors.white, size: checkMarkSize);
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
          onTap: this.onTap,
          child: Container(
            padding: EdgeInsets.all(SpacingValues.small),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                checkMark,
                SizedBox(width: SpacingValues.large),
                Flexible(
                  child: Text(this.text, style: TextThemes.onboardBody),
                )
              ],
            ),
          )),
    );
  }
}
