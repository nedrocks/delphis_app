import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/bloc/me/me_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'discussion_list_event.dart';
part 'discussion_list_state.dart';

class DiscussionListBloc
    extends Bloc<DiscussionListEvent, DiscussionListState> {
  final DiscussionRepository repository;
  final MeBloc meBloc;

  DiscussionListBloc({
    @required this.repository,
    @required this.meBloc,
  }) : super(DiscussionListInitial());

  @override
  Stream<DiscussionListState> mapEventToState(
    DiscussionListEvent event,
  ) async* {
    var prevList = this.state.discussionList;
    if(event is DiscussionListFetchEvent && !(this.state is DiscussionListLoading)) {
      try {
        yield DiscussionListLoading(discussionList: prevList, timestamp: DateTime.now());
        var newList;
        if (meBloc.state is LoadedMeState) {
          try {
            newList = await this.repository.getMyDiscussionList();
          } catch (err) {
            newList = await this.repository.getDiscussionList();
          }
        } else {
          newList = await this.repository.getDiscussionList();
        }
        yield DiscussionListLoaded(discussionList: newList, timestamp: DateTime.now());
      }
      catch (error) {
        // TODO: Format user-friendly error
        yield DiscussionListError(discussionList: prevList, error: error,timestamp: DateTime.now());
      }
    }
  }
}
