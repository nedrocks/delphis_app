import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/user.dart';
import 'package:equatable/equatable.dart';

enum DiscussionInviteMode { EVERYONE_FOLLOWED, EVERYONE_APPROVED }

class UpsertDiscussionInfo extends Equatable {
  final User meUser;
  final Discussion discussion;
  final String title;
  final String description;
  final DiscussionInviteMode inviteMode;
  final String inviteLink;
  final bool isNewDiscussion;

  UpsertDiscussionInfo({
    this.meUser,
    this.discussion,
    this.title,
    this.description,
    this.inviteMode,
    this.inviteLink,
    this.isNewDiscussion = true,
  });

  UpsertDiscussionInfo copyWith({
    meUser,
    discussion,
    title,
    description,
    inviteMode,
    inviteLink,
    isNewDiscussion,
  }) {
    return UpsertDiscussionInfo(
        meUser: meUser ?? this.meUser,
        discussion: discussion ?? this.discussion,
        title: title ?? this.title,
        description: description ?? this.description,
        inviteMode: inviteMode ?? this.inviteMode,
        inviteLink: inviteLink ?? this.inviteLink,
        isNewDiscussion: isNewDiscussion ?? this.isNewDiscussion);
  }

  @override
  List<Object> get props => [
        this.discussion,
        this.title,
        this.description,
        this.inviteMode,
        this.inviteLink,
        this.isNewDiscussion
      ];
}
