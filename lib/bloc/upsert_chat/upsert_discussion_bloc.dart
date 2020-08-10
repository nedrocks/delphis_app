import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/bloc/upsert_chat/upsert_discussion_info.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/discussion_creation_settings.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

part 'upsert_discussion_event.dart';
part 'upsert_discussion_state.dart';

class UpsertDiscussionBloc
    extends Bloc<UpsertDiscussionEvent, UpsertDiscussionState> {
  final DiscussionRepository discussionRepository;

  UpsertDiscussionBloc(this.discussionRepository)
      : super(UpsertDiscussionReadyState(UpsertDiscussionInfo()));

  @override
  Stream<UpsertDiscussionState> mapEventToState(
    UpsertDiscussionEvent event,
  ) async* {
    if (this.state is UpsertDiscussionLoadingState) {
      /* We don't want anything to happen while something is loading.
         it would be dangerous and a threat to state consistency. */
    } else if (event is UpsertDiscussionMeUserChangeEvent) {
      final updated = this.state.info.copyWith(meUser: event.me);
      yield UpsertDiscussionReadyState(updated);
    } else if (event is UpsertDiscussionSelectDiscussionEvent &&
        event.discussion != null) {
      final updated = this.state.info.copyWith(
            discussion: event.discussion,
            title: event.discussion.title,
            description: event.discussion.description,
            inviteMode: event.discussion.discussionJoinability,
            isNewDiscussion: false,
          );
      yield UpsertDiscussionReadyState(updated);
    } else if (event is UpsertDiscussionSetTitleDescriptionEvent) {
      final updated = this.state.info.copyWith(
          title: event.title,
          description: event.description,
          overrideDescription: true);
      yield UpsertDiscussionReadyState(updated);
    } else if (event is UpsertDiscussionSetInviteModeEvent) {
      final updated = this.state.info.copyWith(
            inviteMode: event.inviteMode,
          );
      yield UpsertDiscussionReadyState(updated);
    } else if (event is UpsertDiscussionCreateDiscussionEvent) {
      final info = this.state.info;
      yield UpsertDiscussionCreateLoadingState(info);
      try {
        if (((info.title?.length ?? 0) == 0) || info.inviteMode == null) {
          throw Intl.message("You didn't insert all the required fields");
        }

        final discussion = await this.discussionRepository.createDiscussion(
            title: info.title,
            description: info.description,
            anonymityType: AnonymityType.WEAK,
            creationSettings: DiscussionCreationSettings(
              discussionJoinability: info.inviteMode,
            ));
        yield UpsertDiscussionReadyState(info.copyWith(
          discussion: discussion,
          isNewDiscussion: false,
          inviteLink: discussion.discussionAccessLink.url,
        ));
      } catch (error) {
        yield UpsertDiscussionErrorState(this.state.info, error);
      }
    } else if (event is UpsertDiscussionUpdateDiscussionEvent) {
      final info = this.state.info;
      yield UpsertDiscussionCreateLoadingState(info);
      try {
        if (((info.title?.length ?? 0) == 0) || info.inviteMode == null) {
          throw Intl.message("You didn't insert all the required fields");
        }

        final discussion = await this.discussionRepository.updateDiscussion(
              this.state.info.discussion.id,
              DiscussionInput(
                title: info.title,
                description: info.description,
                discussionJoinability: info.inviteMode,
              ),
            );

        yield UpsertDiscussionReadyState(info.copyWith(
          discussion: discussion,
          isNewDiscussion: false,
        ));
      } catch (error) {
        yield UpsertDiscussionErrorState(this.state.info, error);
      }
    }
  }
}
