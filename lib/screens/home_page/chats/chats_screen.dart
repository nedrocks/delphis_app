import 'package:delphis_app/bloc/discussion_list/discussion_list_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/screens/discussion/discussion.dart';
import 'package:delphis_app/screens/home_page/chats/chats_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatsScreen extends StatefulWidget {
  final DiscussionRepository discussionRepository;
  final RouteObserver routeObserver;

  const ChatsScreen({
    @required this.discussionRepository,
    @required this.routeObserver,
  }) : super();

  @override
  State<StatefulWidget> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> with RouteAware {
  RefreshController _refreshController;
  GlobalKey _chatListKey;

  DiscussionListBloc _discussionListBloc;

  @override
  void dispose() {
    this._discussionListBloc.close();
    this.widget.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    this._refreshController = RefreshController(initialRefresh: false);
    this._chatListKey = GlobalKey();
    this._discussionListBloc =
        DiscussionListBloc(repository: this.widget.discussionRepository);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.widget.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    this._discussionListBloc.add(DiscussionListFetchEvent());
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DiscussionListBloc>.value(
      value: this._discussionListBloc,
      child: ChatsList(
        key: this._chatListKey,
        refreshController: this._refreshController,
        onJoinDiscussionPressed: (Discussion discussion) {},
        onDeleteDiscussionInvitePressed: (Discussion discussion) {},
        onDiscussionPressed: (Discussion discussion) {
          Navigator.of(context).pushNamed('/Discussion',
              arguments: DiscussionArguments(discussionID: discussion.id));
        },
      ),
    );
  }
}
