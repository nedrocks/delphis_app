

import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MentionButton extends StatelessWidget {
  final bool isActive;
  final double width;
  final double height;
  final VoidCallback onPressed;
  final bool isDiscussion;

  const MentionButton({
    @required this.onPressed,
    @required this.isActive,
    @required this.width, 
    @required this.height,
    @required this.isDiscussion
  }) : super();
  
  @override
  Widget build(BuildContext context) {
    Widget render = Pressable(
      onPressed: () {
        if(this.isActive && onPressed != null)
          onPressed();        
        return true;
      },
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(this.width * 0.4),
          color: this.isActive
              ? Color.fromRGBO(246, 246, 246, 1.0)
              : Color.fromRGBO(246, 246, 246, 0.4)),
          child: Icon(this.isDiscussion ? Icons.email : Icons.alternate_email, size: this.width / 1.5, color: Color.fromRGBO(11, 12, 16, 1.0)),
    );

    return render;
  }
}