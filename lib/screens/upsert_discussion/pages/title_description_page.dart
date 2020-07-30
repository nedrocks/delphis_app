import 'package:delphis_app/bloc/upsert_chat/upsert_discussion_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/upsert_discussion/pages/base_page_widget.dart';
import 'package:delphis_app/screens/upsert_discussion/widgets/text_field.dart';
import 'package:delphis_app/widgets/animated_size_container/animated_size_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TitleDescriptionPage extends StatefulWidget {
  final String initialTitle;
  final String initialDescription;
  final String nextButtonText;
  final String prevButtonText;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const TitleDescriptionPage({
    Key key,
    @required this.nextButtonText,
    @required this.prevButtonText,
    @required this.onBack,
    @required this.onNext,
    this.initialTitle,
    this.initialDescription,
  }) : super(key: key);

  @override
  _TitleDescriptionPageState createState() => _TitleDescriptionPageState();
}

class _TitleDescriptionPageState extends State<TitleDescriptionPage> {
  TextEditingController titleController;
  TextEditingController descriptionController;
  var error;

  @override
  void initState() {
    this.titleController = TextEditingController();
    this.descriptionController = TextEditingController();
    this.titleController.text = this.widget.initialTitle ?? "";
    this.descriptionController.text = this.widget.initialDescription ?? "";
    super.initState();
  }

  @override
  void dispose() {
    this.titleController.dispose();
    this.descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          height: height,
          child: BasePageWidget(
            title: "New Discussion",
            nextButtonChild: Text(
              this.widget.nextButtonText,
              style: TextThemes.joinButtonTextChatTab,
            ),
            backButtonChild: Text(this.widget.prevButtonText),
            onBack: this.widget.onBack,
            onNext: () => this.onNext(context),
            contents: Expanded(
              child: Container(
                margin: EdgeInsets.all(SpacingValues.extraLarge),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                'assets/images/app_icon/image.png',
                                width: MediaQuery.of(context).size.width * 0.2,
                              ),
                            ),
                            SizedBox(
                              height: SpacingValues.mediumLarge,
                            ),
                            Text(
                              Intl.message(
                                  'This lets you create a new conversation for which you will be the moderator.'),
                              style: TextThemes.onboardHeading,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: SpacingValues.smallMedium,
                            ),
                            Text(
                              Intl.message(
                                  'Your identity will be visible to everyone but all participants will be anonymous to each other (and you).'),
                              style: TextThemes.onboardBody,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
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
                          Text(Intl.message('Enter a title for your chat:')),
                          SizedBox(
                            height: SpacingValues.extraSmall,
                          ),
                          UpsertDiscussionTextField(
                            textController: this.titleController,
                            hint: Intl.message("A great title..."),
                            autofocus: false,
                          ),
                          SizedBox(
                            height: SpacingValues.medium,
                          ),
                          Text(Intl.message('A description for your chat:')),
                          SizedBox(
                            height: SpacingValues.extraSmall,
                          ),
                          UpsertDiscussionTextField(
                            textController: this.descriptionController,
                            hint: Intl.message("A cool description..."),
                            autofocus: false,
                            maxLines: 3,
                          ),
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

  void onNext(BuildContext context) {
    var title = titleController.text;
    var description = descriptionController.text;
    setState(() {
      this.error = null;
      if ((title?.length == 0 ?? true)) {
        error = Intl.message("You need to fill the title field.");
      } else if ((description?.length == 0 ?? true)) {
        error = Intl.message("You need to fill the description field.");
      }
      if (error == null && this.widget.onNext != null) {
        BlocProvider.of<UpsertDiscussionBloc>(context).add(
          UpsertDiscussionSetInfoEvent(
            description: description,
            title: title,
          ),
        );
        this.widget.onNext();
      }
    });
  }
}
