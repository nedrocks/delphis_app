import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/data/repository/flair.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/design/colors.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'participant_event.dart';
part 'participant_state.dart';

class ParticipantBloc extends Bloc<ParticipantEvent, ParticipantState> {
  final ParticipantRepository repository;
  final DiscussionBloc discussionBloc;

  StreamSubscription<DiscussionState> discussionBlocSubscription;

  ParticipantBloc({
    @required this.repository,
    @required this.discussionBloc,
  }) : super() {
    if (!(this.discussionBloc.state is DiscussionLoadedState) ||
        this.discussionBloc.state.getDiscussion() == null) {
      discussionBlocSubscription =
          this.discussionBloc.listen((DiscussionState state) {
        if (state is DiscussionLoadedState) {
          this.add(ParticipantEventReceivedParticipant(
              participant: state.getDiscussion().meParticipant));
          discussionBlocSubscription.cancel();
        }
      });
    } else if (this.discussionBloc.state.getDiscussion() != null) {
      this.add(
        ParticipantEventReceivedParticipant(
            participant:
                this.discussionBloc.state.getDiscussion().meParticipant),
      );
    } else {
      // Error state..
    }
  }

  void dispose() {
    this.discussionBlocSubscription.cancel();
  }

  @override
  ParticipantState get initialState => ParticipantInitial();

  @override
  Stream<ParticipantState> mapEventToState(
    ParticipantEvent event,
  ) async* {
    final currentState = this.state;
    if (event is ParticipantEventReceivedParticipant) {
      yield ParticipantLoaded(
          participant: event.participant, isUpdating: false);
    } else if (event is ParticipantEventUpdateParticipant &&
        !(currentState is ParticipantLoaded && currentState.isUpdating)) {
      yield ParticipantLoaded(
          participant: currentState.participant, isUpdating: true);
      var updatedParticipant;
      try {
        updatedParticipant = await this.repository.updateParticipant(
              currentState.participant.id,
              event.gradientName,
              event.flair,
              event.isAnonymous ?? currentState.participant.isAnonymous,
              event.isUnsetFlairID ?? false,
              event.isUnsetGradient ?? false,
            );
      } catch (err) {
        // What to do about this error?
        yield ParticipantLoaded(
            participant: currentState.participant, isUpdating: false);
        return;
      }
      this
          .discussionBloc
          .add(MeParticipantUpdatedEvent(meParticipant: updatedParticipant));
      yield ParticipantLoaded(
        participant: updatedParticipant,
        isUpdating: false,
      );
    } else if (event is ParticipantEventAddParticipant) {
      yield ParticipantLoaded(participant: null, isUpdating: true);
      final addedParticipant = await this.repository.addDiscussionParticipant(
          event.discussionID,
          event.userID,
          gradientColorFromGradientName(event.gradientName),
          event.flairID,
          event.hasJoined,
          event.isAnonymous);

      this
          .discussionBloc
          .add(MeParticipantUpdatedEvent(meParticipant: addedParticipant));
      yield ParticipantLoaded(
        participant: addedParticipant,
        isUpdating: false,
      );
    }
  }
}
