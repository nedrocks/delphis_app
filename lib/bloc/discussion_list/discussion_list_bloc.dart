import 'dart:async';
import 'dart:math';

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
    // TODO: Format user-friendly errors
    var prevList = this.state.discussionList;
    if (event is DiscussionListFetchEvent &&
        !(this.state is DiscussionListLoading)) {
      yield DiscussionListLoading(
        discussionList: prevList,
        timestamp: DateTime.now(),
      );
      try {
        var newList = await this.repository.getDiscussionList();
        yield DiscussionListLoaded(
          discussionList: newList,
          timestamp: DateTime.now(),
        );
      } catch (error) {
        yield DiscussionListError(
          discussionList: prevList,
          error: error,
          timestamp: DateTime.now(),
        );
      }
    } else if (event is DiscussionListDeleteEvent) {
      var listWithoutElement =
          prevList.where((e) => e.id != event.discussion.id).toList();
      /* Yield list excluding the element to be removed. This can provide
         a better UX, as the user thinks that the removal happened istantaneously.
         we add it back with an error message in case something goes wrong. */
      yield DiscussionListLoading(
        discussionList: listWithoutElement,
        timestamp: DateTime.now(),
      );
      try {
        /* TODO: This is mocked behavior for UI testing. We need to hook this
           up with repositories and real backend mutations. */
        Future.delayed(Duration(seconds: 2));
        if (Random().nextInt(3) == 0) {
          throw "some random error";
        }

        /* Yield list excluding the removed element */
        yield DiscussionListLoaded(
          discussionList: listWithoutElement,
          timestamp: DateTime.now(),
        );
      } catch (error) {
        /* Yield list including the element we failed to remove */
        yield DiscussionListError(
          discussionList: prevList,
          error: error,
          timestamp: DateTime.now(),
        );
      }
    } else if (event is DiscussionListMuteEvent) {
      yield DiscussionListLoading(
        discussionList: prevList,
        timestamp: DateTime.now(),
      );
      try {
        /* TODO: This is mocked behavior for UI testing. We need to hook this
           up with repositories and real backend mutations. */
        Future.delayed(Duration(seconds: 2));
        if (Random().nextInt(3) == 0) {
          throw "some random error";
        }

        /* Yield list with updated element */
        yield DiscussionListLoaded(
          discussionList: prevList,
          timestamp: DateTime.now(),
        );
      } catch (error) {
        yield DiscussionListError(
          discussionList: prevList,
          error: error,
          timestamp: DateTime.now(),
        );
      }
    } else if (event is DiscussionListArchiveEvent) {
      yield DiscussionListLoading(
        discussionList: prevList,
        timestamp: DateTime.now(),
      );
      try {
        /* TODO: This is mocked behavior for UI testing. We need to hook this
           up with repositories and real backend mutations. */
        Future.delayed(Duration(seconds: 2));
        if (Random().nextInt(3) == 0) {
          throw "some random error";
        }

        /* Yield list with updated element */
        yield DiscussionListLoaded(
          discussionList: prevList,
          timestamp: DateTime.now(),
        );
      } catch (error) {
        yield DiscussionListError(
          discussionList: prevList,
          error: error,
          timestamp: DateTime.now(),
        );
      }
    }
  }
}
