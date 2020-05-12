import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'discussion_event.dart';
part 'discussion_state.dart';

class DiscussionBloc extends Bloc<DiscussionEvent, DiscussionState> {
  final DiscussionRepository repository;

  DiscussionBloc({
    @required this.repository,
  }) : super();

  @override
  DiscussionState get initialState => DiscussionUninitializedState();

  @override
  Stream<DiscussionState> mapEventToState(DiscussionEvent event) async* {
    final currentState = this.state;
    if (event is DiscussionQueryEvent &&
        !(currentState is DiscussionLoadingState)) {
      try {
        yield DiscussionLoadingState();
        final discussion = await repository.getDiscussion(event.discussionId);
        yield DiscussionLoadedState(discussion);
        return;
      } catch (err) {
        yield DiscussionErrorState(err);
      }
    } else if (event is DiscussionPostsUpdatedEvent) {
      if (currentState.getDiscussion() != null) {
        final updatedDiscussion =
            currentState.getDiscussion().copyWith(posts: event.posts);
        var newState = DiscussionLoadedState(updatedDiscussion);
        yield newState;
      }
    } else if (event is MeParticipantUpdatedEvent) {
      if (currentState.getDiscussion() != null) {
        final updatedDiscussion = currentState
            .getDiscussion()
            .copyWith(meParticipant: event.meParticipant);
        yield DiscussionLoadedState(updatedDiscussion);
      }
      // } else if (event is DiscussionPostAddEvent && currentState is DiscussionLoadedState) {
      //   // TODO: How do we handle simultaneous post add events?
      //   if (currentState.getDiscussion() != null) {
      //     yield DiscussionAddPostState(discussion: currentState.getDiscussion(), postContent: event.postContent, step: PostAddStep.INITIATED);
      //     try {
      //       var addedPost = await repository.addPost(currentState.getDiscussion().id, event.postContent);
      //       var updatedPosts = currentState.getDiscussion().posts..insert(0, addedPost);

      //     }
      //   }
    }
  }
}
