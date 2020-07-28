part of 'create_chat_bloc.dart';

abstract class CreateChatEvent extends Equatable {
  const CreateChatEvent();
}

class StartCreateChatFlow extends CreateChatEvent {
  final DateTime equatableID;

  const StartCreateChatFlow({@required this.equatableID});

  @override
  List<Object> get props => [this.equatableID];
}

class StartCreateChatFlowFromPage extends CreateChatEvent {
  final DateTime equatableID;
  final CreateChatPage startPage;
  final CreateChatPage nextPage;
  final List<Object> chathamInvitedUsers;
  final List<Object> twitterInvitedUsers;
  final String title;
  final String description;
  // Use null when this is creating a new discussion. If updating an existing
  // one fill it in here.
  final String discussionID;

  const StartCreateChatFlowFromPage({
    @required this.equatableID,
    @required this.startPage,
    @required this.nextPage,
    @required this.discussionID,
    this.title,
    this.description,
    this.chathamInvitedUsers,
    this.twitterInvitedUsers,
  }) : super();

  @override
  List<Object> get props => [
        this.equatableID,
        startPage,
        nextPage,
        chathamInvitedUsers,
        twitterInvitedUsers,
        title,
        description
      ];
}

class SaveCreateChatFlow extends CreateChatEvent {
  final DateTime equatableID;
  final List<Object> chathamInvitedUsers;
  final List<Object> twitterInvitedUsers;
  final String title;
  final String description;
  final bool advanceToNextPage;

  const SaveCreateChatFlow({
    @required this.equatableID,
    @required this.advanceToNextPage,
    this.title,
    this.description,
    this.chathamInvitedUsers,
    this.twitterInvitedUsers,
  }) : super();

  @override
  List<Object> get props => [
        this.advanceToNextPage,
        this.equatableID,
        this.title,
        this.description,
        this.chathamInvitedUsers,
        this.twitterInvitedUsers
      ];
}
