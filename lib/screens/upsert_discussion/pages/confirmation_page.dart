import 'package:delphis_app/bloc/notification/notification_bloc.dart';
import 'package:delphis_app/bloc/upsert_chat/upsert_discussion_bloc.dart';
import 'package:delphis_app/bloc/upsert_chat/upsert_discussion_info.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/upsert_discussion/pages/base_page_widget.dart';
import 'package:delphis_app/screens/upsert_discussion/pages/invite_mode_page.dart';
import 'package:delphis_app/screens/upsert_discussion/widgets/bullet_point.dart';
import 'package:delphis_app/widgets/overlay/overlay_top_message.dart';
import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:delphis_app/widgets/text_overlay_notification/incognito_mode_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfirmationPage extends StatelessWidget {
  final String nextButtonText;
  final String prevButtonText;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const ConfirmationPage({
    Key key,
    @required this.nextButtonText,
    @required this.prevButtonText,
    @required this.onBack,
    @required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpsertDiscussionBloc, UpsertDiscussionState>(
      builder: (context, state) {
        if (state is UpsertDiscussionReadyState) {
          final height = MediaQuery.of(context).size.height;
          String inviteMode = '';
          switch (state.info.inviteMode) {
            case DiscussionJoinabilitySetting.ALLOW_TWITTER_FRIENDS:
              inviteMode = InviteModePage.allowTwitterFriendsText;
              break;
            case DiscussionJoinabilitySetting.ALL_REQUIRE_APPROVAL:
              inviteMode = InviteModePage.allRequireApprovalText;
              break;
          }
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Container(
                color: Colors.black,
                height: height,
                child: BasePageWidget(
                  title: "Congratulations!",
                  nextButtonChild: Row(
                    children: <Widget>[
                      Text(
                        this.nextButtonText,
                        style: TextThemes.joinButtonTextChatTab,
                      ),
                      SizedBox(
                        width: SpacingValues.small,
                      ),
                      Icon(Icons.arrow_forward, color: Colors.black),
                    ],
                  ),
                  backDisable: true,
                  onNext: this.onNext,
                  contents: Expanded(
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.all(SpacingValues.extraLarge),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: SvgPicture.asset(
                              'assets/svg/chat-icon.svg',
                              width: 80,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: SpacingValues.xxLarge,
                          ),
                          Text(
                            Intl.message(
                                'Your new discussion has been successfully created.'),
                            style: TextThemes.onboardHeading,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: SpacingValues.mediumLarge,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: SpacingValues.large),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      BulletPoint(
                                        color: Colors.white,
                                        size: TextThemes.onboardBody.fontSize /
                                            1.5,
                                        margin: EdgeInsets.only(
                                            top: (TextThemes
                                                        .onboardBody.fontSize /
                                                    1.5) *
                                                0.3),
                                      ),
                                      SizedBox(width: SpacingValues.large),
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              state.info.title,
                                              style: TextThemes.onboardBody
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: SpacingValues.small,
                                            ),
                                            (state.info.description?.length ??
                                                        0) >
                                                    0
                                                ? Text(
                                                    state.info.description,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: SpacingValues.medium,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      BulletPoint(
                                        color: Colors.white,
                                        size: TextThemes.onboardBody.fontSize /
                                            1.5,
                                        margin: EdgeInsets.only(
                                            top: (TextThemes
                                                        .onboardBody.fontSize /
                                                    1.5) *
                                                0.3),
                                      ),
                                      SizedBox(width: SpacingValues.large),
                                      Flexible(
                                        child: Text(
                                          inviteMode,
                                          style: TextThemes.onboardBody,
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: SpacingValues.large,
                          ),
                          Pressable(
                            height: 50,
                            width: double.infinity,
                            onPressed: () =>
                                copyInvitationLink(context, state.info),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Color.fromRGBO(247, 247, 255, 1.0),
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.content_copy,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: SpacingValues.smallMedium,
                                  ),
                                  Text(
                                    Intl.message('Copy invitation link'),
                                    style: TextThemes.signInWithTwitter,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: SpacingValues.mediumLarge,
                          ),
                          Pressable(
                            height: 50,
                            width: double.infinity,
                            onPressed: () =>
                                sendInvitationTweet(context, state.info),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: ChathamColors.twitterLogoColor,
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/twitter_logo.svg',
                                    color: Colors.black,
                                    width: 32.0,
                                    height: 32.0,
                                  ),
                                  SizedBox(
                                    width: SpacingValues.smallMedium,
                                  ),
                                  Text(
                                    Intl.message('Tweet your invite'),
                                    style: TextThemes.signInWithTwitter,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  void sendInvitationTweet(
      BuildContext context, UpsertDiscussionInfo info) async {
    String url = Uri.https("twitter.com", "/intent/tweet", {
      "text": Intl.message(
          "I’m moderating a discussion: “${info.title}”.\n\nJoin:"),
      "url": info.inviteLink
    }).toString();
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void copyInvitationLink(BuildContext context, UpsertDiscussionInfo info) {
    Clipboard.setData(ClipboardData(text: info.inviteLink));
    BlocProvider.of<NotificationBloc>(context).add(
      NewNotificationEvent(
        notification: OverlayTopMessage(
          child: IncognitoModeTextOverlay(
            hasGoneIncognito: false,
            textOverride: Intl.message(
                "An invitation link to this discussion was copied to clipboard!"),
          ),
          onDismiss: () {
            BlocProvider.of<NotificationBloc>(context).add(
              DismissNotification(),
            );
          },
          showForMs: 2000,
        ),
      ),
    );
  }
}
