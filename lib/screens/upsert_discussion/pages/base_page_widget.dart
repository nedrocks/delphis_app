import 'package:delphis_app/bloc/upsert_chat/upsert_discussion_bloc.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/screens/home_page/home_page_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BasePageWidget extends StatelessWidget {
  final Widget contents;
  final String title;
  final Widget backButtonChild;
  final Widget nextButtonChild;
  final bool backDisable;
  final bool nextDisable;
  final Color backColor;
  final Color nextColor;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const BasePageWidget({
    @required this.contents,
    @required this.title,
    this.backButtonChild,
    this.nextButtonChild,
    this.onNext,
    this.onBack,
    this.backDisable = false,
    this.nextDisable = false,
    this.backColor,
    this.nextColor,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: SpacingValues.large),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              color: ChathamColors.topBarBackgroundColor,
            ),
            HomePageTopBar(
              height: 80.0,
              title: Intl.message(title),
              backgroundColor: ChathamColors.topBarBackgroundColor,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Center(
                    child: this.contents,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                this.backDisable
                    ? Container()
                    : RaisedButton(
                        padding: EdgeInsets.symmetric(
                          horizontal: SpacingValues.large,
                          vertical: SpacingValues.medium,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        color: this.backColor ??
                            Color.fromRGBO(247, 247, 255, 0.2),
                        child: this.backButtonChild,
                        onPressed: this.onBack,
                        animationDuration: Duration(milliseconds: 100),
                      ),
                this.nextDisable
                    ? Container()
                    : BlocBuilder<UpsertDiscussionBloc, UpsertDiscussionState>(
                        builder: (context, state) {
                          var doNext = this.onNext;
                          var opacity = 1.0;
                          if (state is UpsertDiscussionLoadingState) {
                            doNext = null;
                            opacity = 0.5;
                          }
                          return Opacity(
                            opacity: opacity,
                            child: RaisedButton(
                              padding: EdgeInsets.symmetric(
                                horizontal: SpacingValues.xxLarge,
                                vertical: SpacingValues.medium,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              color: this.nextColor ??
                                  Color.fromRGBO(247, 247, 255, 1.0),
                              child: this.nextButtonChild,
                              onPressed: doNext,
                              splashColor: Colors.grey.withOpacity(0.8),
                              animationDuration: Duration(milliseconds: 100),
                            ),
                          );
                        },
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
