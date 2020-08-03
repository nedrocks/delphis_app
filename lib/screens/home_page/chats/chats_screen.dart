import 'package:delphis_app/bloc/discussion_list/discussion_list_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:delphis_app/screens/discussion/screen_args/discussion.dart';
import 'package:delphis_app/screens/home_page/chats/chats_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatsScreen extends StatefulWidget {
  final DiscussionRepository discussionRepository;
  final RouteObserver routeObserver;
  final User currentUser;

  ChatsScreen({
    @required this.discussionRepository,
    @required this.routeObserver,
    @required this.currentUser,
  }) : super();

  @override
  State<StatefulWidget> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> with RouteAware {
  RefreshController _refreshController;
  GlobalKey _chatListKey;
  SlidableController slidableController;

  @override
  void dispose() {
    this.widget.routeObserver.unsubscribe(this);
    this.slidableController?.activeState?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    this.slidableController = SlidableController();
    this._refreshController = RefreshController(initialRefresh: false);
    this._chatListKey = GlobalKey();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.widget.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    BlocProvider.of<DiscussionListBloc>(context)
        .add(DiscussionListFetchEvent());
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return ChatsList(
      currentUser: this.widget.currentUser,
      key: this._chatListKey,
      refreshController: this._refreshController,
      onJoinDiscussionPressed: (Discussion discussion) {
        Navigator.of(context).pushNamed('/Discussion',
            arguments: DiscussionArguments(
              discussionID: discussion.id,
              isStartJoinFlow: true,
            ));
      },
      onDiscussionPressed: (Discussion discussion) {
        Navigator.of(context).pushNamed('/Discussion',
            arguments: DiscussionArguments(discussionID: discussion.id));
      },
      slidableController: slidableController,
      onDeleteDiscussionPressed: (Discussion discussion) {
        // TODO: Hook this up to backend mutations somehow
      },
      onArchiveDiscussionPressed: (Discussion discussion) {
        // TODO: Hook this up to backend mutations somehow
      },
      onMuteDiscussionPressed: (Discussion discussion) {
        // TODO: Hook this up to backend mutations somehow
      },
    );
  }
}
