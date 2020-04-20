import 'package:delphis_app/data/repository/post.dart';
import 'package:delphis_app/widgets/anon_profile_image/anon_profile_image.dart';
import 'package:flutter/material.dart';

class DiscussionPostProfileImage extends StatelessWidget {
  final Post post;
  final double diameter;

  const DiscussionPostProfileImage({
    @required this.post,
    @required this.diameter,
  }): super();

  @override
  Widget build(BuildContext context) {
    // TODO: Add switch as to whether the poster is anon or not.
    // return AnonProfileImage(
    //   height: this.diameter,
    //   width: this.diameter,
    //   borderShape: BoxShape.circle,

    // )
    return null;
  }
}