import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/bloc/me/me_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/discussion_access.dart';
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
    }

    /* From this point on, events related to mute/unmute/archive/restore/delete 
       features are handled. Each one of them has been implemented in non-blocking
       fashion. A state with a successful simulated result is emitted immediately,
       and the operation is executed asynchronously. Once completed, the BLoC will
       receive an async internal event that will yield another state depending on
       the effective outcome of the operation, both in case of error or success.
       Accordingly, every operation has a dedicated event, which is the one usable
       by extern classes, and two internal events not visible out of this BLoC scope,
       one for the async error case and one for the async success case.
       
       Since we have 3 different panels and list of discussions (active, archived,
       and deleted), we have to consider that each operation must have restrictions
       or certain semantics on each list. In the following implementation, this
       has been assumed:
       
       Active Chats:
         - Chats can be deleted, archived, muted, and unmuted.
         - There is no "active flag", a chat is active if it is in the active list
         - Chats can be in this list only if they are not archived nor deleted
         - A chat might temporarily believe that it is not active if one of the flags
           isDeletedLocally or isArchivedLocally is set to true in Discussion.
         - A chat can be muted only if it is unmuted
         - A chat can be unmuted only if it is muted
       Archived Chats:
         - Chats can be deleted and restored (a.k.a. re-activated)
         - There is no "archived flag", a chat is archived if it is in the archived list
         - Chats can be in this list only if they are nor active or deleted
         - A chat might temporarily believe that it is not archived if one of the flags
           isDeletedLocally or isActivatedLocally is set to true in Discussion.
       Deleted Chats:
         - No operation can be applied to these chats
         - There is no "deleted flag", a chat is deleted if it is in the deleted list
         - Chats can be in this list only if they are nor active or archived
      
      Part of the semantics above has been implemented by restricting the actions
      available in the UI for each case.

      This helps maintaining the local discussion lists in a consistent state. A
      complete refresh from the backend will remove any inconsistency.
    */
    else if (event is DiscussionListDeleteEvent) {
      var transform = (Discussion e) {
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
          // await Future.delayed(Duration(seconds: 2));
          // if (Random().nextInt(2) == 0) {
          //   throw "some random error";
          // }
          // var updatedDiscussion = event.discussion;
          await this.repository.updateDiscussionUserSettings(
              event.discussion.id, DiscussionUserAccessState.DELETED, null);
          this.add(_DiscussionListDeleteAsyncSuccessEvent(event.discussion));
        } catch (error) {
          this.add(
              _DiscussionListDeleteAsyncErrorEvent(event.discussion, error));
        }
      }();
    } else if (event is _DiscussionListDeleteAsyncErrorEvent) {
      var transform = (Discussion e) {
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
      var transform = (Discussion e) => e.id != event.discussion.id;
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
      var transform = (Discussion e) {
        if (e.id == event.discussion.id) {
          return e.copyWith(isArchivedLocally: true);
        }
        return e;
      };
      var activeListWithoutElement = prevActiveList.map(transform).toList();
      yield DiscussionListLoaded(
        activeDiscussions: activeListWithoutElement,
        archivedDiscussions: prevArchivedList,
        deletedDiscussions: prevDeletedList,
        timestamp: DateTime.now(),
      );
      () async {
        try {
          /* TODO: This is mocked behavior for UI testing. We need to hook this
           up with repositories and real backend mutations. */
          await this.repository.updateDiscussionUserSettings(
              event.discussion.id, DiscussionUserAccessState.ARCHIVED, null);
          this.add(_DiscussionListDeleteAsyncSuccessEvent(event.discussion));
        } catch (error) {
          this.add(
              _DiscussionListArchiveAsyncErrorEvent(event.discussion, error));
        }
      }();
    } else if (event is _DiscussionListArchiveAsyncErrorEvent) {
      var transform = (Discussion e) {
        if (e.id == event.discussion.id) {
          return e.copyWith(isArchivedLocally: false);
        }
        return e;
      };
      var activeListWithElement = prevActiveList.map(transform).toList();
      yield DiscussionListError(
        activeDiscussions: activeListWithElement,
        archivedDiscussions: prevArchivedList,
        deletedDiscussions: prevDeletedList,
        error: event.error,
        timestamp: DateTime.now(),
      );
    } else if (event is _DiscussionListArchiveAsyncSuccessEvent) {
      var transform = (Discussion e) => e.id != event.discussion.id;
      var updatedActiveList = prevActiveList.where(transform).toList();
      var updatedArchivedList = [event.discussion] + prevArchivedList;
      yield DiscussionListLoaded(
        activeDiscussions: updatedActiveList,
        archivedDiscussions: updatedArchivedList,
        deletedDiscussions: prevDeletedList,
        timestamp: DateTime.now(),
      );
    } else if (event is DiscussionListMuteEvent) {
      var transform = (Discussion e) {
        if (e.id == event.discussion.id) {
          return e.copyWith(
            mutedUntil: DateTime.now().add(
              Duration(seconds: event.mutedForSeconds),
            ),
          );
        }
        return e;
      };
      var activeEditedListElement = prevActiveList.map(transform).toList();
      yield DiscussionListLoaded(
        activeDiscussions: activeEditedListElement,
        archivedDiscussions: prevArchivedList,
        deletedDiscussions: prevDeletedList,
        timestamp: DateTime.now(),
      );
      () async {
        try {
          /* TODO: This is mocked behavior for UI testing. We need to hook this
           up with repositories and real backend mutations. */
          // await Future.delayed(Duration(seconds: 2));
          // if (Random().nextInt(2) == 0) {
          //   throw "some random error";
          // }
          // var updatedDiscussion = event.discussion.copyWith(
          //   mutedUntil: DateTime.now().add(
          //     Duration(seconds: event.mutedForSeconds),
          //   ),
          // );
          // this.add(_DiscussionListMuteAsyncSuccessEvent(updatedDiscussion));
          await this.repository.updateDiscussionUserSettings(
              event.discussion.id,
              null,
              DiscussionUserNotificationSetting.NONE);
          this.add(_DiscussionListDeleteAsyncSuccessEvent(event.discussion));
        } catch (error) {
          this.add(_DiscussionListMuteAsyncErrorEvent(event.discussion, error));
        }
      }();
    } else if (event is _DiscussionListMuteAsyncErrorEvent) {
      var transform = (Discussion e) {
        if (e.id == event.discussion.id) {
          return e.copyWith(
            mutedUntil: event.discussion.mutedUntil ??
                DateTime.now().subtract(
                  Duration(minutes: 1),
                ),
          );
        }
        return e;
      };
      var activeListWithElement = prevActiveList.map(transform).toList();
      yield DiscussionListError(
        activeDiscussions: activeListWithElement,
        archivedDiscussions: prevArchivedList,
        deletedDiscussions: prevDeletedList,
        error: event.error,
        timestamp: DateTime.now(),
      );
    } else if (event is _DiscussionListMuteAsyncSuccessEvent) {
      var updatedActiveList = prevActiveList.map((e) {
        if (e.id == event.discussion.id) {
          return event.discussion;
        }
        return e;
      }).toList();
      yield DiscussionListLoaded(
        activeDiscussions: updatedActiveList,
        archivedDiscussions: prevArchivedList,
        deletedDiscussions: prevDeletedList,
        timestamp: DateTime.now(),
      );
    } else if (event is DiscussionListUnMuteEvent) {
      var transform = (Discussion e) {
        if (e.id == event.discussion.id) {
          return e.copyWith(
            mutedUntil: DateTime.now().subtract(
              Duration(minutes: 1),
            ),
          );
        }
        return e;
      };
      var activeEditedListElement = prevActiveList.map(transform).toList();
      yield DiscussionListLoaded(
        activeDiscussions: activeEditedListElement,
        archivedDiscussions: prevArchivedList,
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
          var updatedDiscussion = event.discussion.copyWith(
            mutedUntil: DateTime.now().subtract(
              Duration(minutes: 1),
            ),
          );
          this.add(_DiscussionListUnMuteAsyncSuccessEvent(updatedDiscussion));
        } catch (error) {
          this.add(
              _DiscussionListUnMuteAsyncErrorEvent(event.discussion, error));
        }
      }();
    } else if (event is _DiscussionListUnMuteAsyncErrorEvent) {
      var transform = (Discussion e) {
        if (e.id == event.discussion.id) {
          return e.copyWith(mutedUntil: event.discussion.mutedUntil);
        }
        return e;
      };
      var activeListWithElement = prevActiveList.map(transform).toList();
      yield DiscussionListError(
        activeDiscussions: activeListWithElement,
        archivedDiscussions: prevArchivedList,
        deletedDiscussions: prevDeletedList,
        error: event.error,
        timestamp: DateTime.now(),
      );
    } else if (event is _DiscussionListUnMuteAsyncSuccessEvent) {
      var updatedActiveList = prevActiveList.map((e) {
        if (e.id == event.discussion.id) {
          return event.discussion;
        }
        return e;
      }).toList();
      yield DiscussionListLoaded(
        activeDiscussions: updatedActiveList,
        archivedDiscussions: prevArchivedList,
        deletedDiscussions: prevDeletedList,
        timestamp: DateTime.now(),
      );
    } else if (event is DiscussionListActivateEvent) {
      var transform = (Discussion e) {
        if (e.id == event.discussion.id) {
          return e.copyWith(isActivatedLocally: true);
        }
        return e;
      };
      var archivedListWithoutElement = prevArchivedList.map(transform).toList();
      yield DiscussionListLoaded(
        activeDiscussions: prevActiveList,
        archivedDiscussions: archivedListWithoutElement,
        deletedDiscussions: prevDeletedList,
        timestamp: DateTime.now(),
      );
      () async {
        try {
          /* TODO: This is mocked behavior for UI testing. We need to hook this
           up with repositories and real backend mutations. */
          await this.repository.updateDiscussionUserSettings(
              event.discussion.id, DiscussionUserAccessState.ACTIVE, null);
          this.add(_DiscussionListDeleteAsyncSuccessEvent(event.discussion));
        } catch (error) {
          this.add(
              _DiscussionListActivateAsyncErrorEvent(event.discussion, error));
        }
      }();
    } else if (event is _DiscussionListActivateAsyncErrorEvent) {
      var transform = (Discussion e) {
        if (e.id == event.discussion.id) {
          return e.copyWith(isActivatedLocally: false);
        }
        return e;
      };
      var archivedListWithElement = prevArchivedList.map(transform).toList();
      yield DiscussionListError(
        activeDiscussions: prevActiveList,
        archivedDiscussions: archivedListWithElement,
        deletedDiscussions: prevDeletedList,
        error: event.error,
        timestamp: DateTime.now(),
      );
    } else if (event is _DiscussionListActivateAsyncSuccessEvent) {
      var transform = (Discussion e) => e.id != event.discussion.id;
      var updatedArchivedList = prevArchivedList.where(transform).toList();
      var updatedActiveList = [event.discussion] + prevActiveList;
      yield DiscussionListLoaded(
        activeDiscussions: updatedActiveList,
        archivedDiscussions: updatedArchivedList,
        deletedDiscussions: prevDeletedList,
        timestamp: DateTime.now(),
      );
    }
  }
}
