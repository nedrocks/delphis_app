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
    var currentState = this.state;
    if (event is DiscussionQueryEvent &&
        !(currentState is DiscussionLoadingState)) {
      try {
        yield DiscussionLoadingState();
        final discussion = await repository.getDiscussion(event.discussionID);
        yield DiscussionLoadedState(
            discussion: discussion, lastUpdate: DateTime.now());
      } catch (err) {
        yield DiscussionErrorState(err);
      }
    } else if (event is DiscussionPostsUpdatedEvent) {
      if (currentState.getDiscussion() != null) {
        final updatedDiscussion =
            currentState.getDiscussion().copyWith(posts: event.posts);
        var newState = DiscussionLoadedState(
            discussion: updatedDiscussion, lastUpdate: DateTime.now());
        yield newState;
      }
    } else if (event is MeParticipantUpdatedEvent) {
      if (currentState.getDiscussion() != null) {
        final updatedDiscussion = currentState
            .getDiscussion()
            .copyWith(meParticipant: event.meParticipant);
        yield DiscussionLoadedState(
            discussion: updatedDiscussion, lastUpdate: DateTime.now());
      }
    } else if (event is DiscussionPostAddEvent &&
        currentState is DiscussionLoadedState &&
        !(currentState is DiscussionAddPostState)) {
      if (currentState.getDiscussion() != null) {
        yield DiscussionAddPostState(
            discussion: currentState.getDiscussion(),
            postContent: event.postContent,
            step: PostAddStep.INITIATED,
            lastUpdate: DateTime.now());
        try {
          var addedPost = await repository.addPost(
              currentState.getDiscussion().id, event.postContent);
          var updatedPosts = currentState.getDiscussion().posts
            ..insert(0, addedPost);
          var updatedDiscussion = currentState.getDiscussion().copyWith(
                posts: updatedPosts,
              );
          currentState = DiscussionAddPostState(
              discussion: updatedDiscussion,
              postContent: event.postContent,
              step: PostAddStep.SUCCESS,
              lastUpdate: DateTime.now());
          yield currentState;
          yield DiscussionLoadedState(
              discussion: updatedDiscussion, lastUpdate: DateTime.now());
        } catch (err) {
          yield DiscussionAddPostState(
              discussion: currentState.getDiscussion(),
              postContent: event.postContent,
              step: PostAddStep.ERROR,
              lastUpdate: DateTime.now());
          yield DiscussionLoadedState(
              discussion: currentState.getDiscussion(),
              lastUpdate: DateTime.now());
        }
      }
    } else if (event is DiscussionPostAddedEvent &&
        currentState is DiscussionLoadedState) {
      if (currentState.getDiscussion() != null) {
        var found = false;
        final discussion = currentState.getDiscussion();
        for (int i = 0; i < discussion.posts.length; i++) {
          if (discussion.posts[i].id == event.post.id) {
            found = true;
            break;
          } else if (discussion.posts[i]
              .createdAtAsDateTime()
              .isBefore(event.post.createdAtAsDateTime())) {
            found = false;
            break;
          }
        }
        if (!found) {
          // This post is new.
          var updatedPosts = currentState.getDiscussion().posts
            ..insert(0, event.post);
          var updatedDiscussion = currentState.getDiscussion().copyWith(
                posts: updatedPosts,
              );
          yield currentState.update(discussion: updatedDiscussion);
        }
      }
    } else if (event is SubscribeToDiscussionEvent &&
        currentState is DiscussionLoadedState) {
      if (currentState.getDiscussion() != null &&
          currentState.discussionPostStream == null) {
        final discussionStream =
            await this.repository.subscribe(currentState.getDiscussion().id);
        discussionStream.listen((Post post) {
          this.add(DiscussionPostAddedEvent(post: post));
        });
        yield currentState.update(stream: discussionStream);
      }
    }
  }
}
