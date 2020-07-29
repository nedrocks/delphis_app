import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/data/repository/discussion_invite.dart';
import 'package:delphis_app/data/repository/twitter_user.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'twitter_invitation_event.dart';
part 'twitter_invitation_state.dart';

class TwitterInvitationBloc
    extends Bloc<TwitterInvitationEvent, TwitterInvitationState> {
  final UserRepository repository;
  final TwitterUserRepository twitterUserRepository;

  TwitterInvitationBloc({this.repository, this.twitterUserRepository})
      : super(TwitterInvitationInitialState());

  @override
  Stream<TwitterInvitationState> mapEventToState(
    TwitterInvitationEvent event,
  ) async* {
    if (event is TwitterInvitationResetEvent) {
      yield TwitterInvitationInitialState();
    } else if (event is TwitterInvitationInviteEvent &&
        !(this.state is TwitterInvitationLoadingState)) {
      yield TwitterInvitationInviteLoadingState(timestamp: DateTime.now());

      try {
        var invites = await twitterUserRepository.inviteUsersToDiscussion(
            event.discussionID,
            event.invitingParticipantID,
            event.invitedTwitterUsers);
        yield TwitterInvitationInviteSuccessState(invites: invites);
      } catch (error) {
        yield TwitterInvitationErrorState(
            timestamp: DateTime.now(), error: error);
      }
    } else if (event is TwitterInvitationSearchEvent) {
      yield TwitterInvitationSearchLoadingState(
          timestamp: DateTime.now(), query: event.query);

      try {
        var autocompletes =
            await twitterUserRepository.getUserInfoAutocompletes(
                event.query, event.discussionID, event.invitingParticipantID);
        yield TwitterInvitationSearchSuccessState(
            timestamp: DateTime.now(),
            query: event.query,
            autocompletes: autocompletes);
      } catch (error) {
        yield TwitterInvitationErrorState(
            timestamp: DateTime.now(), error: error);
      }
    }
  }
}
