import 'package:json_annotation/json_annotation.dart';

import 'participant.dart';
import 'user_profile.dart';
import 'viewer.dart';

part 'user.g.dart';


@JsonSerializable()
class User {
  final String id;
  final List<Participant> participants;
  final List<Viewer> viewers;
  final UserProfile profile;

  const User({
    this.id,
    this.participants,
    this.viewers,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}