import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'discussion_subscription.g.dart';

@JsonSerializable()
class DiscussionSubscriptionEvent extends Equatable {
  final DiscussionSubscriptionEventType eventType;

  const DiscussionSubscriptionEvent({
    this.eventType
  });
  
  factory DiscussionSubscriptionEvent.fromJson(Map<String, dynamic> json) {
    var obj = _$DiscussionSubscriptionEventFromJson(json);
    switch(obj.eventType) {
      case DiscussionSubscriptionEventType.POST_ADDED:
        return DiscussionSubscriptionPostAdded(post: Post.fromJson(json["entity"]));
      case DiscussionSubscriptionEventType.POST_DELETED:
        return DiscussionSubscriptionPostDeleted(post: Post.fromJson(json["entity"]));
      case DiscussionSubscriptionEventType.PARTICIPANT_BANNED:
        return DiscussionSubscriptionParticipantBanned(participant: Participant.fromJson(json["entity"]));
    }
    throw "Unknown DiscussionSubscriptionEvent type";
  }

  @override
  List<Object> get props => [eventType];

}

enum DiscussionSubscriptionEventType {
    POST_ADDED,
    POST_DELETED,
    PARTICIPANT_BANNED
}

class DiscussionSubscriptionPostAdded extends DiscussionSubscriptionEvent{
  final Post post;

  get eventType => DiscussionSubscriptionEventType.POST_ADDED;
  
  DiscussionSubscriptionPostAdded({
    @required this.post
  });

  @override
  List<Object> get props => [post];
  
}

class DiscussionSubscriptionPostDeleted extends DiscussionSubscriptionEvent{
  final Post post;

  get eventType => DiscussionSubscriptionEventType.POST_DELETED;
  
  DiscussionSubscriptionPostDeleted({
    @required this.post
  });
  
  @override
  List<Object> get props => [post];

}

class DiscussionSubscriptionParticipantBanned extends DiscussionSubscriptionEvent{
  final Participant participant;

  get eventType => DiscussionSubscriptionEventType.PARTICIPANT_BANNED;
  
  DiscussionSubscriptionParticipantBanned({
    @required this.participant
  });

  @override
  List<Object> get props => [participant];
  
}