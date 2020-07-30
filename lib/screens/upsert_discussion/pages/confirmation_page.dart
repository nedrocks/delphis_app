import 'package:delphis_app/bloc/upsert_chat/upsert_discussion_bloc.dart';
import 'package:delphis_app/bloc/upsert_chat/upsert_discussion_info.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/upsert_discussion/pages/base_page_widget.dart';
import 'package:delphis_app/screens/upsert_discussion/pages/invite_mode_page.dart';
import 'package:delphis_app/widgets/animated_size_container/animated_size_container.dart';
import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ConfirmationPage extends StatelessWidget {
  final String nextButtonText;
  final String prevButtonText;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onRetry;

  const ConfirmationPage({
    Key key,
    @required this.nextButtonText,
    @required this.prevButtonText,
    @required this.onBack,
    @required this.onNext,
    @required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpsertDiscussionBloc, UpsertDiscussionState>(
      builder: (context, state) {
        if (state is UpsertDiscussionLoadingState ||
            state is UpsertDiscussionErrorState) {
          return buildDuringCreation(context, state);
        } else if (state is UpsertDiscussionReadyState) {
          return buildConfirmation(context, state.info);
        }
        return Container();
      },
    );
  }

  Widget buildDuringCreation(
      BuildContext context, UpsertDiscussionState state) {
    final height = MediaQuery.of(context).size.height;
    String title = Intl.message("Loading...");
    if (state is UpsertDiscussionErrorState) {
      title = Intl.message("Uh oh!");
    }
    Widget content = Container();
    if (state is UpsertDiscussionLoadingState) {
      content = Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                Intl.message(
                    "We are creating your new discussion, please hold on a little longer..."),
                style: TextThemes.onboardBody,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SpacingValues.large),
              CircularProgressIndicator()
            ],
          ),
        ),
      );
    } else if (state is UpsertDiscussionErrorState) {
      content = Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                state.error.toString(),
                textAlign: TextAlign.center,
                style: TextThemes.onboardBody.copyWith(
                  color: Colors.red,
                ),
              ),
              SizedBox(height: SpacingValues.large),
              Pressable(
                height: 50,
                width: double.infinity,
                onPressed: this.onRetry,
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
                      Text(
                        Intl.message('Try again'),
                        style: TextThemes.signInWithTwitter,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: SpacingValues.small),
              RaisedButton(
                padding: EdgeInsets.symmetric(
                  horizontal: SpacingValues.xxxxLarge,
                  vertical: SpacingValues.medium,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                color: Color.fromRGBO(247, 247, 255, 0.2),
                child: Text(Intl.message("Go back")),
                onPressed: this.onBack,
                animationDuration: Duration(milliseconds: 100),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: BasePageWidget(
            title: title,
            backDisable: true,
            nextDisable: true,
            contents: Expanded(
              child: Container(
                margin: EdgeInsets.all(SpacingValues.extraLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/app_icon/image.png',
                      width: 96.0,
                      height: 96.0,
                    ),
                    SizedBox(height: SpacingValues.large),
                    AnimatedSizeContainer(
                      builder: (context) {
                        return content;
                      },
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

  Widget buildConfirmation(BuildContext context, UpsertDiscussionInfo info) {
    final height = MediaQuery.of(context).size.height;
    String inviteMode = '';
    switch (info.inviteMode) {
      case DiscussionInviteMode.EVERYONE_FOLLOWED:
        inviteMode = InviteModePage.everyoneFollowedText;
        break;
      case DiscussionInviteMode.EVERYONE_APPROVED:
        inviteMode = InviteModePage.everyoneApprovedText;
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
                      margin:
                          EdgeInsets.symmetric(horizontal: SpacingValues.large),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _BulletPoint(
                                  color: Colors.white,
                                  size: TextThemes.onboardBody.fontSize / 1.5,
                                ),
                                SizedBox(width: SpacingValues.large),
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        info.title,
                                        style: TextThemes.onboardBody.copyWith(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: SpacingValues.small,
                                      ),
                                      Text(
                                        info.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _BulletPoint(
                                  color: Colors.white,
                                  size: TextThemes.onboardBody.fontSize / 1.5,
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
                      onPressed: () => copyInvitationLink(context, info),
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
                      onPressed: () => sendInvitationTweet(context, info),
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

  void sendInvitationTweet(BuildContext context, UpsertDiscussionInfo info) {
    // TODO: Sent real tweet
  }

  void copyInvitationLink(BuildContext context, UpsertDiscussionInfo info) {
    // TODO: Copy to clipboard and send notification to user
  }
}

class _BulletPoint extends StatelessWidget {
  final Color color;
  final double size;

  const _BulletPoint({Key key, @required this.color, @required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: size * 0.3),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
