import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'discussion.dart';
import 'post.dart';
import 'viewer.dart';

part 'participant.g.dart';

@JsonSerializable()
class Participant extends Equatable {
  final int participantID;
  final Discussion discussion;
  final Viewer viewer;
  final List<Post> posts;

  List<Object> get props => [participantID, discussion, viewer, posts];

  const Participant({
    this.participantID,
    this.discussion,
    this.viewer,
    this.posts,
  });

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);
}
