
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverlayAlertDialog extends OverlayEntry {
  
  OverlayAlertDialog({
    @required Widget title,
    @required Widget content,
    @required List<Widget> actions
  }) : super(
    builder : (context) => _buildEntry(context, title, content, actions)
      );
    
  static Widget _buildEntry(BuildContext context, Widget title, Widget content, List<Widget> actions) {
    return SafeArea(
      child: Container(
        color: Colors.grey.withOpacity(0.7),
        child: GestureDetector(
          onTap: () => false,
          child: Center(
            child: CupertinoAlertDialog(
              title: title,
              content: content,
              actions: actions
            ),
          )
        )
      ),
    );
  }

}