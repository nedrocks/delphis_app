import 'package:json_annotation/json_annotation.dart';

import 'discussion.dart';
import 'user_profile.dart';

part 'moderator.g.dart';

@JsonSerializable()
class Moderator {
  final String id;
  final Discussion discussion;
  final UserProfile userProfile;

  const Moderator({
    this.id,
    this.discussion,
    this.userProfile,
  });

  factory Moderator.fromJson(Map<String, dynamic> json) => _$ModeratorFromJson(json);
}