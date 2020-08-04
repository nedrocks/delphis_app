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
    var prevActiveList = this.state.activeDiscussions;
    var prevArchivedList = this.state.archivedDiscussions;
    var prevDeletedList = this.state.deletedDiscussions;
    if (event is DiscussionListFetchEvent &&
        !(this.state is DiscussionListLoading)) {
      yield DiscussionListLoading(
        activeDiscussions: prevActiveList,
        archivedDiscussions: prevArchivedList,
        deletedDiscussions: prevDeletedList,
        timestamp: DateTime.now(),
      );
      try {
        // TODO: Fetch 3 different lists
        var newList = await this.repository.getDiscussionList();
        yield DiscussionListLoaded(
          activeDiscussions: newList,
          archivedDiscussions: [],
          deletedDiscussions: [],
          timestamp: DateTime.now(),
        );
      } catch (error) {
        yield DiscussionListError(
          activeDiscussions: prevActiveList,
          archivedDiscussions: prevArchivedList,
          deletedDiscussions: prevDeletedList,
          error: error,
          timestamp: DateTime.now(),
        );
      }
    } else if (event is DiscussionListDeleteEvent) {
      /* In order to provide a more responsive UX, we want to make the user
         believe that the requested action happened instantly. For the same
         reason we consume this event even if the current state is "loading". 
         To achieve this, we yield a "loaded" state that simulates a successful
         outcome of the requested operation. The real task is then executed as
         an async function, which fires an "error" event to this bloc only in
         case something goes wrong. Those "error" events are not visible outside
         of this class scope. */
      var transform = (e) {
        if (e.id == event.discussion.id) {
          return e.copyWith(isDeletedLocally: true);
        }
        return e;
      };
      var activeListWithoutElement = prevActiveList.map(transform).toList();
      var archivedListWithoutElement = prevArchivedList.map(transform).toList();
      yield DiscussionListLoaded(
        activeDiscussions: activeListWithoutElement,
        archivedDiscussions: archivedListWithoutElement,
        deletedDiscussions: prevDeletedList,
        timestamp: DateTime.now(),
      );
      () async {
        try {
          /* TODO: This is mocked behavior for UI testing. We need to hook this
           up with repositories and real backend mutations. */
          await Future.delayed(Duration(seconds: 2));
          if (Random().nextInt(2) == 0) {
            throw "some random error";
          }
          this.add(_DiscussionListDeleteAsyncSuccessEvent(event.discussion));
        } catch (error) {
          this.add(
              _DiscussionListDeleteAsyncErrorEvent(event.discussion, error));
        }
      }();
    } else if (event is _DiscussionListDeleteAsyncErrorEvent) {
      /* This event is asynchronously fired by this bloc internally in case 
         something went wrong with the requested operation. We restore the
         changes that we pretended to be successful, and yield an error state
         accordingly. */
      var transform = (e) {
        if (e.id == event.discussion.id) {
          return e.copyWith(isDeletedLocally: false);
        }
        return e;
      };
      var activeListWithElement = prevActiveList.map(transform).toList();
      var archivedListWithElement = prevArchivedList.map(transform).toList();
      yield DiscussionListError(
        activeDiscussions: activeListWithElement,
        archivedDiscussions: archivedListWithElement,
        deletedDiscussions: prevDeletedList,
        error: event.error,
        timestamp: DateTime.now(),
      );
    } else if (event is _DiscussionListDeleteAsyncSuccessEvent) {
      /* This event is asynchronously fired by this bloc internally in case 
         everything has been executed flawlessly. We finalize the changes
         requested. */
      var transform = (e) => e.id != event.discussion.id;
      var updatedActiveList = prevActiveList.where(transform).toList();
      var updatedArchivedList = prevArchivedList.where(transform).toList();
      var updatedDeletedList = [event.discussion] + prevDeletedList;
      yield DiscussionListLoaded(
        activeDiscussions: updatedActiveList,
        archivedDiscussions: updatedArchivedList,
        deletedDiscussions: updatedDeletedList,
        timestamp: DateTime.now(),
      );
    } else if (event is DiscussionListArchiveEvent) {
    } else if (event is _DiscussionListArchiveAsyncErrorEvent) {
    } else if (event is _DiscussionListArchiveAsyncSuccessEvent) {
    } else if (event is DiscussionListMuteEvent) {
    } else if (event is _DiscussionListMuteAsyncErrorEvent) {
    } else if (event is DiscussionListUnMuteEvent) {
    } else if (event is _DiscussionListUnMuteAsyncErrorEvent) {
    } else if (event is DiscussionListActivateEvent) {
    } else if (event is _DiscussionListActivateAsyncErrorEvent) {
    } else if (event is _DiscussionListActivateAsyncSuccessEvent) {}
  }
}
