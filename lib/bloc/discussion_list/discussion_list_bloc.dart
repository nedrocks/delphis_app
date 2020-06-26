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
  }) : super();

  @override
  DiscussionListState get initialState => DiscussionListInitial();

  @override
  Stream<DiscussionListState> mapEventToState(
    DiscussionListEvent event,
  ) async* {
    final currentState = this.state;
    if (event is DiscussionListFetchEvent &&
        (!(currentState is DiscussionListLoaded && currentState.isLoading))) {
      List<Discussion> currentList;
      if (currentState is DiscussionListLoaded) {
        currentList = currentState.discussionList;
      }

      yield DiscussionListLoaded(discussionList: currentList, isLoading: true, visibleDiscussionList: currentList);
      try {
        var visibleList = await this.repository.getMyDiscussionList();
        var currentList = await this.repository.getDiscussionList();
        if (meBloc.state is LoadedMeState) {
          try {
            currentList = visibleList;
          } catch (err) { }
        }
        yield DiscussionListLoaded(
            discussionList: currentList, isLoading: false, visibleDiscussionList: visibleList);
      } catch (err) {
        if (currentList == null) {
          yield DiscussionListInitial();
        } else {
          yield DiscussionListLoaded(
              discussionList: currentList, isLoading: false, visibleDiscussionList: currentList);
        }
      }
    }
  }
}
