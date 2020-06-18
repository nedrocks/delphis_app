import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'discussion.dart';
import 'user_profile.dart';

part 'moderator.g.dart';

@JsonSerializable()
class Moderator extends Equatable {
  final String id;
  final Discussion discussion;
  final UserProfile userProfile;

  @override
  List<Object> get props => [id, discussion, userProfile];

  const Moderator({
    this.id,
    this.discussion,
    this.userProfile,
  });

  factory Moderator.fromJson(Map<String, dynamic> json) =>
      _$ModeratorFromJson(json);
}
