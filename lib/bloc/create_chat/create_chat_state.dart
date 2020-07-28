part of 'create_chat_bloc.dart';

abstract class CreateChatState extends Equatable {
  const CreateChatState();
}

enum CreateChatPage {
  TITLE_AND_DESCRIPTION,
  INVITE_INSTRUCTIONS,
  INVITE_PAGE,
  CONFIRMATION_PAGE,
  FINISHED
}

class CreateChatFlowNotActive extends CreateChatState {
  const CreateChatFlowNotActive() : super();

  List<Object> get props => [];
}

class CreateChatFlowState extends CreateChatState {
  final CreateChatPage currentPage;
  final CreateChatPage nextPage;
  final String title;
  final String description;
  // TODO: These won't be objects but not sure what types they should be yet.
  final List<Object> chathamInvitedUsers;
  final List<Object> twitterInvitedUsers;
  final String discussionID;

  CreateChatFlowState({
    this.currentPage,
    nextPage,
    this.title,
    this.description,
    this.chathamInvitedUsers,
    this.twitterInvitedUsers,
    this.discussionID,
  })  : this.nextPage = CreateChatFlowState.getNextPage(currentPage, nextPage),
        super();

  static CreateChatPage getNextPage(
      CreateChatPage currentPage, CreateChatPage nextPage) {
    if (nextPage != null) {
      return nextPage;
    }

    if (currentPage == null) {
      return null;
    }

    final values = CreateChatPage.values;
    final currentIndex = values.indexOf(currentPage);
    if (currentIndex == -1 || currentIndex == values.length - 1) {
      return null;
    }

    return values[currentIndex + 1];
  }

  @override
  List<Object> get props => [
        currentPage,
        nextPage,
        title,
        description,
        chathamInvitedUsers,
        twitterInvitedUsers,
        discussionID,
      ];

  CreateChatFlowState update({
    CreateChatPage currentPage,
    CreateChatPage nextPage,
    String updatedTitle,
    String updatedDescription,
    List<Object> chathamInvitedUsers,
    List<Object> twitterInvitedUsers,
  }) {
    CreateChatPage calculatedNextPage;
    if (currentPage == null) {
      calculatedNextPage = nextPage ?? this.nextPage;
    } else if (nextPage != null) {
      calculatedNextPage = this.nextPage;
    } else {
      calculatedNextPage =
          CreateChatFlowState.getNextPage(currentPage, nextPage);
    }
    return CreateChatFlowState(
      discussionID: this.discussionID,
      currentPage: currentPage ?? this.currentPage,
      nextPage: calculatedNextPage,
      title: updatedTitle ?? this.title,
      description: updatedDescription ?? this.description,
      chathamInvitedUsers: chathamInvitedUsers ?? this.chathamInvitedUsers,
      twitterInvitedUsers: twitterInvitedUsers ?? this.twitterInvitedUsers,
    );
  }
}
