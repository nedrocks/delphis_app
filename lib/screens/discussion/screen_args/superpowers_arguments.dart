import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:flutter/material.dart';

class SuperpowersArguments {
  final Post post;
  final Discussion discussion;
  final Participant participant;

  SuperpowersArguments({
    @required this.post,
    @required this.discussion,
    @required this.participant,
  });
  
}