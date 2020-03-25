import 'package:flutter/material.dart';

class AnonProfileImage extends StatelessWidget {
  final double height;
  final double width;

  const AnonProfileImage({
    this.height,
    this.width,
  }): super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/anon_face_transparent/anon_face_transparent.png'),
        ),
        border: Border.all(color: Colors.blueGrey),
      ),
    );
  }
}