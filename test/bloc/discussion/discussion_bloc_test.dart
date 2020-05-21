import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_objects.dart';

class MockDiscussionRepository extends Mock implements DiscussionRepository {}

class DiscussionBlocWithSettableState extends DiscussionBloc {
  final DiscussionState initState;

  bool isLikelyPendingPostOverride;

  DiscussionBlocWithSettableState({
    @required repository,
    @required this.initState,
  }) : super(repository: repository);

  @override
  DiscussionState get initialState => this.initState;

  @override
  bool isLikelyPendingPost(
      DiscussionLoadedState state, Discussion discussion, Post post) {
    if (this.isLikelyPendingPostOverride != null) {
      return this.isLikelyPendingPostOverride;
    }
    return super.isLikelyPendingPost(state, discussion, post);
  }
}

void main() {
  MockDiscussionRepository discussionRepository;

  setUp(() {
    discussionRepository = MockDiscussionRepository();
  });

  group('DiscussionPostAddedEvent mapping', () {
    final discussion = TestObjects.getDiscussion1(asAnonymous: false);

    test('when currentState is not DiscussionLoadedState', () {
      final discussionBloc = DiscussionBlocWithSettableState(
          repository: discussionRepository,
          initState: DiscussionUninitializedState());
      final post = Post(id: '1');
      expect(discussionBloc.state, discussionBloc.initialState);
      expectLater(
        discussionBloc,
        emitsInOrder([discussionBloc.initialState, emitsDone]),
      );

      discussionBloc.add(DiscussionPostAddedEvent(post: post));
      discussionBloc.close();
    });

    group('when current state is DiscussionLoadedState', () {
      final state = DiscussionLoadedState(
          discussion: discussion, lastUpdate: DateTime.now());
      DiscussionBlocWithSettableState bloc;
      setUp(() {
        bloc = DiscussionBlocWithSettableState(
            repository: discussionRepository, initState: state);
      });
      tearDown(() {
        bloc?.close();
      });

      test('when isLikelyPendingPost returns true it early exits', () {
        bloc.isLikelyPendingPostOverride = true;
        final post = Post(id: '1');

        expectLater(bloc, emitsInOrder([bloc.initialState, emitsDone]));

        bloc.add(DiscussionPostAddedEvent(post: post));
        bloc.close();
      });
    });
  });

  group('isLikelyPendingPost', () {
    DiscussionBloc discussionBloc;
    final discussion = TestObjects.getDiscussion1(asAnonymous: false);

    setUp(() {
      discussionBloc = DiscussionBloc(repository: discussionRepository);
    });

    tearDown(() {
      discussionBloc?.close();
    });

    test('when state has no local posts', () {
      final post = Post();
      final state = DiscussionLoadedState(
          discussion: discussion, lastUpdate: DateTime.now());

      expect(
          discussionBloc.isLikelyPendingPost(state, discussion, post), false);
    });

    test('when local post content does not match', () {
      final post = Post(content: 'foo');
      final localPost = LocalPost(
        post: Post(content: 'bar'),
        failCount: 0,
        isProcessing: true,
        isFailed: false,
        key: GlobalKey(),
      );
      final state = DiscussionLoadedState(
        discussion: discussion,
        lastUpdate: DateTime.now(),
        localPosts: {localPost.key: localPost},
      );

      expect(
          discussionBloc.isLikelyPendingPost(state, discussion, post), false);
    });

    test('when local post matches but is not processing', () {
      final post = Post(content: 'bar');
      final localPost = LocalPost(
        post: Post(content: 'bar'),
        failCount: 0,
        isProcessing: false,
        isFailed: false,
        key: GlobalKey(),
      );
      final state = DiscussionLoadedState(
        discussion: discussion,
        lastUpdate: DateTime.now(),
        localPosts: {localPost.key: localPost},
      );

      expect(
          discussionBloc.isLikelyPendingPost(state, discussion, post), false);
    });

    test('when local post matches content and meParticipant', () {
      final post = Post(content: 'bar', participant: discussion.meParticipant);
      final localPost = LocalPost(
        post: Post(content: 'bar'),
        failCount: 0,
        isProcessing: true,
        isFailed: false,
        key: GlobalKey(),
      );
      final state = DiscussionLoadedState(
        discussion: discussion,
        lastUpdate: DateTime.now(),
        localPosts: {localPost.key: localPost},
      );

      expect(discussionBloc.isLikelyPendingPost(state, discussion, post), true);
    });

    test(
        'when local post matches content, mismatches meParticipant, but matches another availableMeParticipant',
        () {
      var otherMeParticipant;
      for (final part in discussion.meAvailableParticipants) {
        if (part.id != discussion.meParticipant.id) {
          otherMeParticipant = part;
        }
      }
      expect(otherMeParticipant, isNotNull);
      final post = Post(content: 'bar', participant: otherMeParticipant);
      final localPost = LocalPost(
        post: Post(content: 'bar'),
        failCount: 0,
        isProcessing: true,
        isFailed: false,
        key: GlobalKey(),
      );
      final state = DiscussionLoadedState(
        discussion: discussion,
        lastUpdate: DateTime.now(),
        localPosts: {localPost.key: localPost},
      );

      expect(discussionBloc.isLikelyPendingPost(state, discussion, post), true);
    });

    test(
        'when local post matches content, is processing, but does not match meAvailableParticipants',
        () {
      final post = Post(
          content: 'bar',
          participant: Participant(id: 'some-totally-unmatched-id'));
      final localPost = LocalPost(
        post: Post(content: 'bar'),
        failCount: 0,
        isProcessing: true,
        isFailed: false,
        key: GlobalKey(),
      );
      final state = DiscussionLoadedState(
        discussion: discussion,
        lastUpdate: DateTime.now(),
        localPosts: {localPost.key: localPost},
      );

      expect(
          discussionBloc.isLikelyPendingPost(state, discussion, post), false);
    });
  });
}
