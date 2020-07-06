import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:flutter/material.dart';

class ModeratorPopupArguments {
  final Post selectedPost;
  final Discussion selectedDiscussion;

  ModeratorPopupArguments({
    @required this.selectedPost,
    @required this.selectedDiscussion
  });
  
}