import 'package:delphis_app/bloc/auth/auth_bloc.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/upsert_discussion/pages/base_page_widget.dart';
import 'package:delphis_app/widgets/animated_size_container/animated_size_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class TwitterAuthPage extends StatelessWidget {
  final String nextButtonText;
  final String prevButtonText;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const TwitterAuthPage({
    Key key,
    @required this.nextButtonText,
    @required this.prevButtonText,
    @required this.onBack,
    @required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final twitterWidgetHeight = 76.0;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: BasePageWidget(
            title: "Authentication",
            nextButtonChild: Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/twitter_logo.svg',
                  color: ChathamColors.twitterLogoColor,
                  semanticsLabel: 'Twitter Logo',
                  width: 28.0,
                  height: 23.0,
                ),
                SizedBox(width: SpacingValues.medium),
                Text(
                  this.nextButtonText,
                  style: TextThemes.joinButtonTextChatTab,
                ),
              ],
            ),
            backButtonChild: Text(this.prevButtonText),
            onBack: this.onBack,
            onNext: () {},
            contents: Expanded(
              child: Container(
                margin: EdgeInsets.all(SpacingValues.extraLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/svg/twitter_logo.svg',
                          color: ChathamColors.signInTwitterBackground,
                          semanticsLabel: 'Twitter Logo',
                          width: 96,
                          height: twitterWidgetHeight,
                        ),
                      ),
                    ),
                    AnimatedSizeContainer(
                      builder: (context) {
                        return BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is LoadingAuthState) {
                              return CircularProgressIndicator();
                            }
                            return Container();
                          },
                        );
                      },
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Intl.message(
                                "In order to invite a curated list of participants, moderators need to be able to identify themselves so that the participants can trust them."),
                            style: TextThemes.onboardHeading,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: SpacingValues.mediumLarge),
                          Text(
                              Intl.message(
                                  "You can do so by authenticating through social media for now."),
                              style: TextThemes.onboardBody,
                              textAlign: TextAlign.center),
                        ],
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
}
