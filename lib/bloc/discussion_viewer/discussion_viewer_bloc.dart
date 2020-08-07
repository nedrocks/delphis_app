import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:delphis_app/data/repository/viewer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'discussion_viewer_event.dart';
part 'discussion_viewer_state.dart';

class DiscussionViewerBloc
    extends Bloc<DiscussionViewerEvent, DiscussionViewerState> {
  final ViewerRepository viewerRepository;

  DiscussionViewerBloc({
    @required this.viewerRepository,
  }) : super(DiscussionViewerUnInitialized());

  @override
  Stream<Transition<DiscussionViewerEvent, DiscussionViewerState>>
      transformEvents(Stream<DiscussionViewerEvent> events, transitionFn) {
    final defferedEvents = events
        .where((e) => e is DiscussionViewerSetLastPostViewedEvent)
        .debounceTime(const Duration(milliseconds: 5000))
        .distinct()
        .switchMap(transitionFn);
    final forwardedEvents = events
        .where((e) => e is! DiscussionViewerSetLastPostViewedEvent)
        .asyncExpand(transitionFn);
    return forwardedEvents.mergeWith([defferedEvents]);
  }

  @override
  Stream<DiscussionViewerState> mapEventToState(
    DiscussionViewerEvent event,
  ) async* {
    final currentState = this.state;
    if (currentState is DiscussionViewerUnInitialized &&
        event is DiscussionViewerLoadedEvent) {
      yield DiscussionViewerInitialized(
        viewer: event.viewer,
        lastUpdateSent: null,
        pendingUpdate: null,
        isUpdating: false,
      );
    } else if (currentState is DiscussionViewerInitialized &&
        event is DiscussionViewerSetLastPostViewedEvent) {
      if (currentState.isUpdating) {
        // We want to delay this for the future!
        this.add(event);
        return;
      }
      if (currentState.pendingUpdate != null &&
          currentState.pendingUpdate
              .createdAtAsDateTime()
              .isBefore(event.post.createdAtAsDateTime())) {
        return;
      }
      // A few other checks here:
      if (event.post == null ||
          (currentState.viewer.lastViewedPost != null &&
              event.post.createdAtAsDateTime().isAfter(
                  currentState.viewer.lastViewedPost.createdAtAsDateTime()))) {
        // In either of these cases we want to not send any information!
        return;
      }

      yield currentState.copyWith(
        pendingUpdate: event.post,
        isUpdating: true,
      );
      try {
        final updatedViewer = await viewerRepository.setLastPostViewed(
            currentState.viewer.id, event.post.id);
        yield currentState.copyWith(
          pendingUpdate: null,
          lastUpdateSent: updatedViewer.lastViewed,
          viewer: updatedViewer,
          isUpdating: false,
        );
      } catch (err) {
        yield currentState.copyWith(
          pendingUpdate: currentState.pendingUpdate,
          isUpdating: false,
        );
        this.add(event);
      }
    }
  }
}
