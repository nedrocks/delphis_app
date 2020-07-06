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
    final currentState = this.state;
    if (event is DiscussionListFetchEvent &&
        (!(currentState is DiscussionListLoaded && currentState.isLoading))) {
      List<Discussion> currentList;
      if (currentState is DiscussionListLoaded) {
        currentList = currentState.discussionList;
      }

      yield DiscussionListLoaded(discussionList: currentList, isLoading: true);
      try {
        if (meBloc.state is LoadedMeState) {
          try {
            currentList = await this.repository.getMyDiscussionList();
          } catch (err) {
            currentList = await this.repository.getDiscussionList();
          }
        } else {
          currentList = await this.repository.getDiscussionList();
        }
        yield DiscussionListLoaded(
            discussionList: currentList, isLoading: false);
      } catch (err) {
        if (currentList == null) {
          yield DiscussionListInitial();
        } else {
          yield DiscussionListLoaded(
              discussionList: currentList, isLoading: false);
        }
      }
    }
  }
}
