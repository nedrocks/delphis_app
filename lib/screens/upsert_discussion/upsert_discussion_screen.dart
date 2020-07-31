import 'package:delphis_app/bloc/auth/auth_bloc.dart';
import 'package:delphis_app/bloc/upsert_chat/upsert_discussion_bloc.dart';
import 'package:delphis_app/bloc/upsert_chat/upsert_discussion_info.dart';
import 'package:delphis_app/screens/discussion/screen_args/discussion.dart';
import 'package:delphis_app/screens/upsert_discussion/pages/confirmation_page.dart';
import 'package:delphis_app/screens/upsert_discussion/pages/creation_loading_page.dart';
import 'package:delphis_app/screens/upsert_discussion/pages/invite_mode_page.dart';
import 'package:delphis_app/screens/upsert_discussion/pages/title_description_page.dart';
import 'package:delphis_app/screens/upsert_discussion/pages/twitter_auth_page.dart';
import 'package:delphis_app/screens/upsert_discussion/screen_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

enum UpsertDiscussionScreenPage {
  TITLE_DESCRIPTION,
  TWITTER_AUTH,
  INVITATION_MODE,
  CREATION_LOADING,
  CONFIRMATION
}

class UpsertDiscussionScreen extends StatefulWidget {
  static const pageFlowOrder = [
    UpsertDiscussionScreenPage.TITLE_DESCRIPTION,
    UpsertDiscussionScreenPage.TWITTER_AUTH,
    UpsertDiscussionScreenPage.INVITATION_MODE,
    UpsertDiscussionScreenPage.CREATION_LOADING,
    UpsertDiscussionScreenPage.CONFIRMATION
  ];
  final UpsertDiscussionArguments arguments;

  const UpsertDiscussionScreen({Key key, this.arguments}) : super(key: key);
  @override
  _UpsertDiscussionScreenState createState() => _UpsertDiscussionScreenState();
}

class _UpsertDiscussionScreenState extends State<UpsertDiscussionScreen>
    with SingleTickerProviderStateMixin {
  UpsertDiscussionScreenPage currentPage;
  TabController tabController;

  int pageToTabIndex(UpsertDiscussionScreenPage page) {
    return UpsertDiscussionScreen.pageFlowOrder.indexOf(page);
  }

  @override
  void initState() {
    currentPage = this.widget.arguments.firstPage ??
        UpsertDiscussionScreenPage.TITLE_DESCRIPTION;
    tabController = TabController(
        vsync: this, length: UpsertDiscussionScreen.pageFlowOrder.length);
    tabController.index = this.widget.arguments.firstPage != null
        ? pageToTabIndex(this.widget.arguments.firstPage)
        : 0;
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpsertDiscussionBloc, UpsertDiscussionState>(
      builder: (context, state) {
        return TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: tabController,
            children: UpsertDiscussionScreen.pageFlowOrder
                .map((page) => mapPageToWidget(context, state.info, page))
                .toList());
      },
    );
  }

  Widget mapPageToWidget(BuildContext context, UpsertDiscussionInfo info,
      UpsertDiscussionScreenPage page) {
    final isUpdate = this.widget.arguments.isUpdateMode;
    switch (page) {
      case UpsertDiscussionScreenPage.TITLE_DESCRIPTION:
        final title =
            (isUpdate || (info.title?.length ?? 0) > 0) ? info.title : null;
        final description = (isUpdate || (info.description?.length ?? 0) > 0)
            ? info.description
            : null;
        return TitleDescriptionPage(
          onBack: () => this.onBack(context, info, page),
          onNext: () => this.onNext(context, info, page),
          prevButtonText: Intl.message("Back"),
          nextButtonText: Intl.message("Continue"),
          initialTitle: title,
          initialDescription: description,
        );
      case UpsertDiscussionScreenPage.TWITTER_AUTH:
        return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is SignedInAuthState && this.onNext != null) {
                this.onNext(context, info, page);
              }
            },
            child: TwitterAuthPage(
              onBack: () => this.onBack(context, info, page),
              onNext: () {
                BlocProvider.of<AuthBloc>(context)
                    .add(TwitterSignInAuthEvent());
              },
              prevButtonText: Intl.message("Back"),
              nextButtonText: Intl.message("Sign in with Twitter"),
            ));
        break;
      case UpsertDiscussionScreenPage.INVITATION_MODE:
        return InviteModePage(
          onBack: () => this.onBack(context, info, page),
          onNext: () => this.onNext(context, info, page),
          prevButtonText: Intl.message("Back"),
          nextButtonText: Intl.message("Create"),
          isUpdateMode: this.widget.arguments.isUpdateMode,
        );
      case UpsertDiscussionScreenPage.CREATION_LOADING:
        return BlocListener<UpsertDiscussionBloc, UpsertDiscussionState>(
          listenWhen: (prev, curr) {
            return prev is UpsertDiscussionCreateLoadingState &&
                curr is UpsertDiscussionReadyState &&
                curr.info.discussion != null;
          },
          listener: (context, state) {
            this.onNext(context, state.info,
                UpsertDiscussionScreenPage.CREATION_LOADING);
          },
          child: CreationLoadingPage(
            onBack: () => this.onBack(context, info, page),
            prevButtonText: Intl.message("Back"),
            onRetry: () {
              BlocProvider.of<UpsertDiscussionBloc>(context).add(
                UpsertDiscussionCreateDiscussionEvent(),
              );
            },
          ),
        );
      case UpsertDiscussionScreenPage.CONFIRMATION:
        return ConfirmationPage(
          onBack: () => this.onBack(context, info, page),
          onNext: () => this.onNext(context, info, page),
          prevButtonText: Intl.message("Back"),
          nextButtonText: Intl.message("Go to chat"),
        );
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
        setState(() {
          this.currentPage = UpsertDiscussionScreenPage.TITLE_DESCRIPTION;
          tabController.animateTo(pageToTabIndex(currentPage));
        });
        break;
      case UpsertDiscussionScreenPage.INVITATION_MODE:
        setState(() {
          this.currentPage = UpsertDiscussionScreenPage.TITLE_DESCRIPTION;
          tabController.animateTo(pageToTabIndex(currentPage));
        });
        break;
      case UpsertDiscussionScreenPage.CREATION_LOADING:
        setState(() {
          this.currentPage = UpsertDiscussionScreenPage.INVITATION_MODE;
          tabController.animateTo(pageToTabIndex(currentPage));
        });
        break;
      case UpsertDiscussionScreenPage.CONFIRMATION:
        setState(() {
          this.currentPage = UpsertDiscussionScreenPage.INVITATION_MODE;
          tabController.animateTo(pageToTabIndex(currentPage));
        });
        break;
    }
  }

  void onNext(BuildContext context, UpsertDiscussionInfo info,
      UpsertDiscussionScreenPage page) {
    // TODO: Handle Update case when we need to show only one page
    switch (page) {
      case UpsertDiscussionScreenPage.TITLE_DESCRIPTION:
        setState(() {
          if (info.meUser == null || !info.meUser.isTwitterAuth) {
            this.currentPage = UpsertDiscussionScreenPage.TWITTER_AUTH;
          } else {
            this.currentPage = UpsertDiscussionScreenPage.INVITATION_MODE;
          }
          tabController.animateTo(pageToTabIndex(currentPage));
        });
        break;
      case UpsertDiscussionScreenPage.TWITTER_AUTH:
        setState(() {
          this.currentPage = UpsertDiscussionScreenPage.INVITATION_MODE;
          tabController.animateTo(pageToTabIndex(currentPage));
        });
        break;
      case UpsertDiscussionScreenPage.INVITATION_MODE:
        setState(() {
          this.currentPage = UpsertDiscussionScreenPage.CREATION_LOADING;
          tabController.animateTo(pageToTabIndex(currentPage));
          BlocProvider.of<UpsertDiscussionBloc>(context)
              .add(UpsertDiscussionCreateDiscussionEvent());
        });
        break;
      case UpsertDiscussionScreenPage.CREATION_LOADING:
        setState(() {
          this.currentPage = UpsertDiscussionScreenPage.CONFIRMATION;
          tabController.animateTo(pageToTabIndex(currentPage));
        });
        break;
      case UpsertDiscussionScreenPage.CONFIRMATION:
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/Discussion',
          ModalRoute.withName("/Home"),
          arguments: DiscussionArguments(
            discussionID: info.discussion.id,
            isStartJoinFlow: false,
          ),
        );
        break;
    }
  }
}
