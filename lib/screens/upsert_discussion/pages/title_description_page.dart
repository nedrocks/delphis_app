import 'package:delphis_app/bloc/upsert_chat/upsert_discussion_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/upsert_discussion/pages/base_page_widget.dart';
import 'package:delphis_app/screens/upsert_discussion/widgets/text_field.dart';
import 'package:delphis_app/widgets/animated_size_container/animated_size_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class TitleDescriptionPage extends StatefulWidget {
  final bool isUpdate;
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
    this.isUpdate = false,
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
    this.titleController.addListener(() {
      setState(() {});
    });
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Colors.black,
        child: BasePageWidget(
          title: this.widget.isUpdate
              ? Intl.message("Edit Discussion")
              : Intl.message("New Discussion"),
          nextButtonChild: Text(
            this.widget.nextButtonText,
            style: TextThemes.joinButtonTextChatTab,
          ),
          backButtonChild: Text(this.widget.prevButtonText),
          onBack: this.widget.onBack,
          onNext: (titleController.text?.length ?? 0) == 0
              ? null
              : () => this.onNext(context),
          nextColor: (titleController.text?.length ?? 0) == 0
              ? Color.fromRGBO(247, 247, 255, 0.5)
              : Color.fromRGBO(247, 247, 255, 1.0),
          contents: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
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
                    this.widget.isUpdate
                        ? Intl.message(
                            'This lets you update title and description of your conversation.')
                        : Intl.message(
                            'This lets you create a new conversation for which you will be the moderator.'),
                    style: TextThemes.onboardHeading,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: SpacingValues.smallMedium,
                  ),
                  Text(
                    this.widget.isUpdate
                        ? Intl.message('Compile the fields below.')
                        : Intl.message(
                            'Your identity will be visible to everyone but all participants will be anonymous to each other (and you).'),
                    style: TextThemes.onboardBody,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: SpacingValues.mediumLarge,
                  ),
                  AnimatedSizeContainer(
                    builder: (context) {
                      if (error != null) {
                        return Column(
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(top: SpacingValues.medium),
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
                  AnimatedSizeContainer(
                    builder: (context) {
                      return BlocBuilder<UpsertDiscussionBloc,
                          UpsertDiscussionState>(
                        builder: (context, state) {
                          if (state is UpsertDiscussionLoadingState) {
                            return Center(child: CircularProgressIndicator());
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
                      );
                    },
                  ),
                  SizedBox(
                    height: SpacingValues.mediumLarge,
                  ),
                  Text(Intl.message('Enter a title for your chat:')),
                  SizedBox(
                    height: SpacingValues.extraSmall,
                  ),
                  UpsertDiscussionTextField(
                    textController: this.titleController,
                    hint: Intl.message("A great title..."),
                    autofocus: false,
                    maxLenght: 50,
                    showLengthCounter: true,
                  ),
                  SizedBox(
                    height: SpacingValues.small,
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
                    maxLenght: 140,
                    showLengthCounter: true,
                  ),
                ],
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
      }
      if (error == null && this.widget.onNext != null) {
        BlocProvider.of<UpsertDiscussionBloc>(context).add(
          UpsertDiscussionSetTitleDescriptionEvent(
            description: description,
            title: title,
          ),
        );
        this.widget.onNext();
      }
    });
  }
}
