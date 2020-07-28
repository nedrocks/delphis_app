import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'create_chat_event.dart';
part 'create_chat_state.dart';

// CreateChat is a slight misnomer here because this bloc is used to track
// the state while either creating or updating a chat.
class CreateChatBloc extends Bloc<CreateChatEvent, CreateChatState> {
  CreateChatBloc() : super(CreateChatFlowNotActive());

  @override
  Stream<CreateChatState> mapEventToState(
    CreateChatEvent event,
  ) async* {
    final currentState = this.state;

    if (event is StartCreateChatFlow &&
        currentState is CreateChatFlowNotActive) {
      yield CreateChatFlowState(
        currentPage: CreateChatPage.TITLE_AND_DESCRIPTION,
        nextPage: CreateChatPage.INVITE_INSTRUCTIONS,
      );
    } else if (event is StartCreateChatFlowFromPage &&
        currentState is CreateChatFlowNotActive) {
      yield CreateChatFlowState(
        currentPage: event.startPage,
        nextPage: event.nextPage,
        title: event.title,
        description: event.description,
        chathamInvitedUsers: event.chathamInvitedUsers,
        twitterInvitedUsers: event.twitterInvitedUsers,
        discussionID: event.discussionID,
      );
    } else if (event is SaveCreateChatFlow &&
        currentState is CreateChatFlowState) {
      var currentPage = currentState.currentPage;
      var nextPage = currentState.nextPage;

      if (event.advanceToNextPage) {
        currentPage = nextPage;
        nextPage = CreateChatFlowState.getNextPage(currentPage, null);
      }

      /*
      * When entering a page that requires backend communication let's show a 
      * loading spinner by filling the `isLoading` <- true. Reasonably this 
      * should be the `INVITE_PAGE` page as well as the `FINISHED` page. The 
      * first should be fetching whatever is required from the backend to do 
      * the twitter / Chatham searching. The second is for saving the updated 
      * discussion and invite lists.
      */

      if (currentPage == CreateChatPage.FINISHED) {
        // TODO: Capture loading state here when necessary.

      }

      yield currentState.update(
        currentPage: currentPage,
        nextPage: nextPage,
        title: event.title,
        description: event.description,
        chathamInvitedUsers: event.chathamInvitedUsers,
        twitterInvitedUsers: event.twitterInvitedUsers,
        isLoading: false,
      );
    }
  }
}
