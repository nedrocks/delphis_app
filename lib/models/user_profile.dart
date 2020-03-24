import 'package:json_annotation/json_annotation.dart';

import 'discussion.dart';
import 'url.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  final String id;
  final String displayName;
  final List<Discussion> moderatedDiscussions;
  final URL twitterURL;
  final String profileImageURL;

  const UserProfile({
    this.id,
    this.displayName,
    this.moderatedDiscussions,
    this.twitterURL,
    this.profileImageURL,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
}