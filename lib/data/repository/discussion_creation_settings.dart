import 'package:delphis_app/data/repository/discussion.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'discussion_creation_settings.g.dart';

@JsonSerializable()
class DiscussionCreationSettings extends Equatable {
  final DiscussionJoinabilitySetting discussionJoinability;

  List<Object> get props => [
        this.discussionJoinability,
      ];

  const DiscussionCreationSettings({@required this.discussionJoinability});

  Map<String, dynamic> toJSON() {
    return _$DiscussionCreationSettingsToJson(this);
  }
}
