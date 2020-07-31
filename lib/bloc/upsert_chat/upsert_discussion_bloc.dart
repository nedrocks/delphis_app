import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/bloc/upsert_chat/upsert_discussion_info.dart';
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

part 'upsert_discussion_event.dart';
part 'upsert_discussion_state.dart';

class UpsertDiscussionBloc
    extends Bloc<UpsertDiscussionEvent, UpsertDiscussionState> {
  final DiscussionRepository discussionRepository;
  var attempt = 0;

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
    } else if (event is UpsertDiscussionSelectDiscussionEvent) {
      final updated = this.state.info.copyWith(
            discussion: event.discussion,
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
          yield UpsertDiscussionErrorState(
              info, Intl.message("You didn't insert all the required fields"));
          return;
        }

        /* The real call must be updated on the backend to support the new flow:
             + description
             + inviteMode
             - anonymityMode (?) */
        // final discussion = await this.discussionRepository.createDiscussion(
        //       title: this.state.info.title,
        //       description: this.state.info.description,
        //       anonymityType: AnonymityType.WEAK,
        //     );

        /* This is mocked for UI development */
        await Future.delayed(Duration(seconds: 2));
        // yield UpsertDiscussionErrorState(
        //     this.state.info, "Something went wrong.");
        if (attempt++ > 1)
          yield UpsertDiscussionReadyState(info.copyWith(
              discussion:
                  Discussion(id: "34bbaab2-eee8-4b64-bbfa-e4c4f71ae5a6"),
              inviteLink:
                  "https://docs.flutter.io/flutter/services/UrlLauncher-class.html"));
        else
          throw "This is an error example for any kind of problem that may occur";
      } catch (error) {
        yield UpsertDiscussionErrorState(this.state.info, error);
      }
    }
  }
}
