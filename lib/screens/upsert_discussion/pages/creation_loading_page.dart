import 'package:delphis_app/bloc/upsert_chat/upsert_discussion_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/upsert_discussion/pages/base_page_widget.dart';
import 'package:delphis_app/widgets/animated_size_container/animated_size_container.dart';
import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CreationLoadingPage extends StatelessWidget {
  final String prevButtonText;
  final VoidCallback onBack;
  final VoidCallback onRetry;

  const CreationLoadingPage({
    Key key,
    @required this.prevButtonText,
    @required this.onBack,
    @required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpsertDiscussionBloc, UpsertDiscussionState>(
      builder: (context, state) {
        if (state is UpsertDiscussionLoadingState ||
            state is UpsertDiscussionErrorState) {
          final height = MediaQuery.of(context).size.height;
          String title = Intl.message("Loading...");
          if (state is UpsertDiscussionErrorState) {
            title = Intl.message("Problem");
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
                      Intl.message(
                          "An error occurred while creating your discussion."),
                      style: TextThemes.onboardBody,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SpacingValues.medium),
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
                              Intl.message('Please try again'),
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
        return Container();
      },
    );
  }
}
