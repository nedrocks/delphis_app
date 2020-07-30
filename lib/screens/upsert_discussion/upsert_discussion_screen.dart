import 'package:delphis_app/bloc/upsert_chat/upsert_discussion_bloc.dart';
import 'package:delphis_app/bloc/upsert_chat/upsert_discussion_info.dart';
import 'package:delphis_app/screens/upsert_discussion/pages/title_description_page.dart';
import 'package:delphis_app/screens/upsert_discussion/screen_arguments.dart';
import 'package:delphis_app/widgets/animated_size_container/animated_size_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

enum UpsertDiscussionScreenPage {
  TITLE_DESCRIPTION,
  TWITTER_AUTH,
  INVITATION_MODE,
  CONFIRMATION
}

class UpsertDiscussionScreen extends StatefulWidget {
  final UpsertDiscussionArguments arguments;

  const UpsertDiscussionScreen({Key key, this.arguments}) : super(key: key);
  @override
  _UpsertDiscussionScreenState createState() => _UpsertDiscussionScreenState();
}

class _UpsertDiscussionScreenState extends State<UpsertDiscussionScreen> {
  UpsertDiscussionScreenPage currentPage;

  @override
  void initState() {
    currentPage = this.widget.arguments.firstPage ??
        UpsertDiscussionScreenPage.TITLE_DESCRIPTION;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpsertDiscussionBloc, UpsertDiscussionState>(
      builder: (context, state) {
        return AnimatedSizeContainer(
          builder: (context) {
            return mapPageToWidget(context, state.info, this.currentPage);
          },
        );
      },
    );
  }

  Widget mapPageToWidget(BuildContext context, UpsertDiscussionInfo info,
      UpsertDiscussionScreenPage page) {
    final isUpdate = this.widget.arguments.isUpdateMode;
    switch (page) {
      case UpsertDiscussionScreenPage.TITLE_DESCRIPTION:
        return TitleDescriptionPage(
          onBack: () => this.onBack(context, info, page),
          onNext: () => this.onNext(context, info, page),
          prevButtonText: Intl.message("Back"),
          nextButtonText: Intl.message("Continue"),
          initialTitle: isUpdate ? info.discussion.title : null,
          initialDescription: isUpdate ? info.discussion.description : null,
        );
      case UpsertDiscussionScreenPage.TWITTER_AUTH:
        // TODO: Handle this case.
        break;
      case UpsertDiscussionScreenPage.INVITATION_MODE:
        // TODO: Handle this case.
        break;
      case UpsertDiscussionScreenPage.CONFIRMATION:
        // TODO: Handle this case.
        break;
    }
    return Container();
  }

  void onBack(BuildContext context, UpsertDiscussionInfo info,
      UpsertDiscussionScreenPage page) {
    switch (page) {
      case UpsertDiscussionScreenPage.TITLE_DESCRIPTION:
        Navigator.of(context).pop();
        break;
      case UpsertDiscussionScreenPage.TWITTER_AUTH:
        // TODO: Handle this case.
        break;
      case UpsertDiscussionScreenPage.INVITATION_MODE:
        // TODO: Handle this case.
        break;
      case UpsertDiscussionScreenPage.CONFIRMATION:
        // TODO: Handle this case.
        break;
    }
  }

  void onNext(BuildContext context, UpsertDiscussionInfo info,
      UpsertDiscussionScreenPage page) {
    // TODO: Handle Update case
    switch (page) {
      case UpsertDiscussionScreenPage.TITLE_DESCRIPTION:
        setState(() {
          if (info.meUser == null || !info.meUser.isTwitterAuth) {
            this.currentPage = UpsertDiscussionScreenPage.TWITTER_AUTH;
          } else {
            this.currentPage = UpsertDiscussionScreenPage.INVITATION_MODE;
          }
        });
        break;
      case UpsertDiscussionScreenPage.TWITTER_AUTH:
        // TODO: Handle this case.
        break;
      case UpsertDiscussionScreenPage.INVITATION_MODE:
        // TODO: Handle this case.
        break;
      case UpsertDiscussionScreenPage.CONFIRMATION:
        // TODO: Handle this case.
        break;
    }
  }
}
