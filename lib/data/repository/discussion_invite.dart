import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/discussion_access.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'discussion_invite.g.dart';

@JsonSerializable()
class DiscussionInvite extends Equatable {
  final String id;
  final Discussion discussion;
  final Participant invitingParticipant;
  final String createdAt;
  final String updateAt;
  final bool isDeleted;
  final InviteRequestStatus status;

  DiscussionInvite(
      {this.id,
      this.discussion,
      this.invitingParticipant,
      this.createdAt,
      this.updateAt,
      this.isDeleted,
      this.status});

  List<Object> get props => [
        id,
        discussion,
        invitingParticipant,
        createdAt,
        updateAt,
        isDeleted,
        status
      ];

  factory DiscussionInvite.fromJson(Map<String, dynamic> json) =>
      _$DiscussionInviteFromJson(json);

  Map<String, dynamic> toJSON() {
    return _$DiscussionInviteToJson(this);
  }
}
