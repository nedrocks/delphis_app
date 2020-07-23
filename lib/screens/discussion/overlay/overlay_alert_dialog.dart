
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
      child: Positioned.fill(
        child: GestureDetector(
          onTap: () => false,
          child: Container(
            color: Colors.black.withOpacity(0.45),
            child: Center(
              child: CupertinoAlertDialog(
                title: title,
                content: content,
                actions: actions
              ),
            ),
          ),
        )
      ),
    );
  }

}