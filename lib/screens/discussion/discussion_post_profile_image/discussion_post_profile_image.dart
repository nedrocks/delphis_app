import 'package:delphis_app/data/repository/post.dart';
import 'package:delphis_app/widgets/anon_profile_image/anon_profile_image.dart';
import 'package:flutter/material.dart';

const BORDER_GRADIENTS = [
  LinearGradient(
    colors: [
      Color.fromRGBO(255, 89, 95, 1.0),
      Color.fromRGBO(224, 32, 32, 1.0),
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  ),
  LinearGradient(
    colors: [
      Color.fromRGBO(247, 181, 0, 1.0),
      Color.fromRGBO(250, 100, 0, 1.0),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
  LinearGradient(
    colors: [
      Color.fromRGBO(244, 225, 8, 1.0),
      Color.fromRGBO(255, 16, 132, 1.0),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
];

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