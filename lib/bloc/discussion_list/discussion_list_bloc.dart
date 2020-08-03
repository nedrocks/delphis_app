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
      /* In order to provide a more responsive UX, we want to make the user
         believe that the requested action happened instantly. For the same
         reason we consume this event even if the current state is "loading". 
         To achieve this, we yield a "loaded" state that simulates a successful
         outcome of the requested operation. The real task is then executed as
         an async function, which fires an "error" event to this bloc only in
         case something goes wrong. Those "error" events are not visible outside
         of this class scope. */
      var listWithoutElement = prevList.map((e) {
        if (e.id == event.discussion.id) {
          return e.copyWith(isDeletedLocally: true);
        }
        return e;
      }).toList();
      yield DiscussionListLoaded(
        discussionList: listWithoutElement,
        timestamp: DateTime.now(),
      );
      () async {
        try {
          /* TODO: This is mocked behavior for UI testing. We need to hook this
           up with repositories and real backend mutations. */
          await Future.delayed(Duration(seconds: 2));
          if (Random().nextInt(3) == 0) {
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
      var updatedList = prevList.map((e) {
        if (e.id == event.discussion.id) {
          return e.copyWith(isDeletedLocally: false);
        }
        return e;
      }).toList();
      yield DiscussionListError(
        discussionList: updatedList,
        error: event.error,
        timestamp: DateTime.now(),
      );
    } else if (event is _DiscussionListDeleteAsyncSuccessEvent) {
      /* This event is asynchronously fired by this bloc internally in case 
         everything has been executed flawlessly. We finalize the changes
         requested. */
      var updatedList =
          prevList.where((e) => e.id == event.discussion.id).toList();
      yield DiscussionListLoaded(
        discussionList: updatedList,
        timestamp: DateTime.now(),
      );
    } else if (event is DiscussionListArchiveEvent) {
      /* See comments reported on DiscussionListDeleteEvent event handler. */
      var wasArchived = false;
      var updatedList = prevList.map((e) {
        if (e.id == event.discussion.id) {
          // TODO: Apply local transformation and change the required flags
          // TODO: wasArchived = ??? retrieve it from object
        }
        return e;
      }).toList();
      yield DiscussionListLoaded(
        discussionList: updatedList,
        timestamp: DateTime.now(),
      );
      () async {
        try {
          /* TODO: This is mocked behavior for UI testing. We need to hook this
           up with repositories and real backend mutations. */
          await Future.delayed(Duration(seconds: 2));
          if (Random().nextInt(3) == 0) {
            throw "some random error";
          }
        } catch (error) {
          this.add(_DiscussionListArchiveAsyncErrorEvent(
              event.discussion, wasArchived, error));
        }
      }();
    } else if (event is _DiscussionListArchiveAsyncErrorEvent) {
      /* See comments reported on _DiscussionListArchiveAsyncErrorEvent event handler */
      var updatedList = prevList.map((e) {
        if (e.id == event.discussion.id) {
          // TODO: Restore old "archived" flag value using event.wasArchived
        }
        return e;
      }).toList();
      yield DiscussionListError(
        discussionList: updatedList,
        error: event.error,
        timestamp: DateTime.now(),
      );
    } else if (event is DiscussionListMuteEvent) {
      /* See comments reported on DiscussionListDeleteEvent event handler. */
      var wasMuted = false;
      var updatedList = prevList.map((e) {
        if (e.id == event.discussion.id) {
          // TODO: Apply local transformation and change the required flags
          // TODO: wasMuted = ??? retrieve it from object
        }
        return e;
      }).toList();
      yield DiscussionListLoaded(
        discussionList: updatedList,
        timestamp: DateTime.now(),
      );
      () async {
        try {
          /* TODO: This is mocked behavior for UI testing. We need to hook this
           up with repositories and real backend mutations. */
          await Future.delayed(Duration(seconds: 2));
          if (Random().nextInt(3) == 0) {
            throw "some random error";
          }
        } catch (error) {
          this.add(_DiscussionListMuteAsyncErrorEvent(
              event.discussion, wasMuted, error));
        }
      }();
    } else if (event is _DiscussionListMuteAsyncErrorEvent) {
      /* See comments reported on _DiscussionListArchiveAsyncErrorEvent event handler */
      var updatedList = prevList.map((e) {
        if (e.id == event.discussion.id) {
          // TODO: Restore old "muted" flag value using event.wasArchived
        }
        return e;
      }).toList();
      yield DiscussionListError(
        discussionList: updatedList,
        error: event.error,
        timestamp: DateTime.now(),
      );
    }
  }
}
