import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'discussion_post_event.dart';
part 'discussion_post_state.dart';

class DiscussionPostBloc
    extends Bloc<DiscussionPostEvent, DiscussionPostState> {
  final DiscussionRepository repository;
  final String discussionID;
  final DiscussionBloc discussionBloc;

  StreamSubscription<DiscussionState> discussionBlocSubscription;
  Stream<Post> discussionPostStream;

  DiscussionPostBloc({
    @required this.repository,
    @required this.discussionBloc,
    @required this.discussionID,
  }) : super() {
    if (!(this.discussionBloc.state is DiscussionLoadedState) ||
        this.discussionBloc.state.getDiscussion() == null) {
      discussionBlocSubscription =
          this.discussionBloc.listen((DiscussionState state) {
        if (state is DiscussionLoadedState) {
          this.add(DiscussionPostsLoadedEvent(
              List<Post>.from(state.getDiscussion().posts)));
          discussionBlocSubscription.cancel();
        }
      });
    } else if (this.discussionBloc.state.getDiscussion() != null) {
      this.add(DiscussionPostsLoadedEvent(
          List<Post>.from(this.discussionBloc.state.getDiscussion().posts)));
    } else {
      // Error state.
    }
  }

  @override
  DiscussionPostState get initialState => DiscussionPostInitialState();

  @override
  Stream<DiscussionPostState> mapEventToState(
    DiscussionPostEvent event,
  ) async* {
    final currentState = this.state;
    if (event is DiscussionPostAddEvent &&
        currentState is DiscussionPostLoadedState) {
      try {
        yield DiscussionPostAddState(
          posts: currentState.posts,
          step: PostAddStep.INITIATED,
          postContent: event.postContent,
        );
        final addedPost =
            await repository.addPost(this.discussionID, event.postContent);
        var updatedPosts = currentState.posts..insert(0, addedPost);
        this.discussionBloc.add(DiscussionPostsUpdatedEvent(updatedPosts));
        yield DiscussionPostAddState(
          posts: updatedPosts,
          step: PostAddStep.SUCCESS,
          postContent: event.postContent,
        );
        await Future.delayed(Duration(seconds: 2), null);
        yield DiscussionPostLoadedState(posts: updatedPosts);
      } catch (err) {
        print(err);
        // We should probably handle this and get out of this state.
        yield DiscussionPostAddState(
          posts: currentState.posts,
          step: PostAddStep.ERROR,
          postContent: event.postContent,
        );
      }
    } else if (event is DiscussionPostAddedEvent) {
      // Noop here right now.
    } else if (event is DiscussionPostsLoadedEvent) {
      yield DiscussionPostLoadedState(posts: event.posts);
      print('about to send subscribe to discussion event');
      this.add(SubscribeToDiscussionEvent(this.discussionID, false));
    } else if (event is SubscribeToDiscussionEvent &&
        this.discussionPostStream == null) {
      print('about to subscribe to stream');
      try {
        this.discussionPostStream =
            this.repository.subscribe(this.discussionID);
        this.discussionPostStream.listen((Post post) {
          this.add(DiscussionPostAddedEvent(post));
        });
        yield currentState;
      } catch (err) {
        print(err);
      }
    }
  }
}
