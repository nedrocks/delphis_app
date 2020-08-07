import 'package:delphis_app/data/repository/user.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'discussion.dart';

part 'discussion_access.g.dart';

enum InviteRequestStatus { ACCEPTED, REJECTED, INVITED, CANCELLED }

@JsonSerializable()
class DiscussionAccessRequest extends Equatable {
  final String id;
  final User user;
  final Discussion discussion;
  final String createdAt;
  final String updatedAt;
  final bool isDeleted;
  final InviteRequestStatus status;

  List<Object> get props => [
        this.id,
        this.user?.id,
        this.discussion?.id,
        this.createdAt,
        this.updatedAt,
        this.isDeleted,
        this.status,
      ];

  const DiscussionAccessRequest({
    this.id,
    this.user,
    this.discussion,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.status,
  });

  factory DiscussionAccessRequest.fromJson(Map<String, dynamic> json) =>
      _$DiscussionAccessRequestFromJson(json);
}
