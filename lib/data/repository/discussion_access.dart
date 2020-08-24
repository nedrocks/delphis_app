import 'package:delphis_app/data/repository/user_profile.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:delphis_app/data/repository/user.dart';

import 'discussion.dart';

part 'discussion_access.g.dart';

enum InviteRequestStatus { ACCEPTED, REJECTED, PENDING, CANCELLED }
enum DiscussionUserAccessState { ACTIVE, ARCHIVED, DELETED, BANNED }
enum DiscussionUserNotificationSetting { NONE, MENTIONS, EVERYTHING }

@JsonSerializable()
class DiscussionAccessRequest extends Equatable {
  final String id;
  final UserProfile userProfile;
  final Discussion discussion;
  final String createdAt;
  final String updatedAt;
  final bool isDeleted;
  final InviteRequestStatus status;

  @JsonKey(ignore: true)
  final bool isLoadingLocally;

  List<Object> get props => [
        this.id,
        this.userProfile?.id,
        this.discussion?.id,
        this.createdAt,
        this.updatedAt,
        this.isDeleted,
        this.status,
      ];

  const DiscussionAccessRequest({
    this.id,
    this.userProfile,
    this.discussion,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.status,
    this.isLoadingLocally = false,
  });

  factory DiscussionAccessRequest.fromJson(Map<String, dynamic> json) =>
      _$DiscussionAccessRequestFromJson(json);

  DiscussionAccessRequest copyWith({
    String id,
    UserProfile userProfile,
    Discussion discussion,
    String createdAt,
    String updatedAt,
    bool isDeleted,
    InviteRequestStatus status,
    bool isLoadingLocally,
  }) {
    return DiscussionAccessRequest(
      id: id ?? this.id,
      userProfile: userProfile ?? this.userProfile,
      discussion: discussion ?? this.discussion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      status: status ?? this.status,
      isLoadingLocally: isLoadingLocally ?? this.isLoadingLocally,
    );
  }
}

@JsonSerializable()
class DiscussionUserAccess extends Equatable {
  final Discussion discussion;
  final User user;
  final DiscussionUserAccessState state;
  final String createdAt;
  final String updatedAt;
  final bool isDeleted;
  final DiscussionAccessRequest request;

  const DiscussionUserAccess({
    this.discussion,
    this.user,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.request,
  });

  List<Object> get props => [
        this.discussion?.id,
        this.user?.id,
        this.state,
        this.isDeleted,
        this.request,
      ];

  factory DiscussionUserAccess.fromJson(Map<String, dynamic> json) =>
      _$DiscussionUserAccessFromJson(json);
}
