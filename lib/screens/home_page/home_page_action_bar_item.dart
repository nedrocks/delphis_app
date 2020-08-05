import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:flutter/material.dart';

class HomePageActionBarItem extends StatelessWidget {
  final VoidCallback onPressed;
  final bool active;
  final Widget icon;
  final String title;

  const HomePageActionBarItem({
    Key key,
    @required this.onPressed,
    @required this.active,
    @required this.title,
    @required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SpacingValues.xxSmall / 2,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Pressable(
            width: constraints.maxHeight,
            height: constraints.maxWidth,
            onPressed: this.onPressed,
            showInkwell: false,
            child: Opacity(
              opacity: this.active ? 1.0 : 0.4,
              child: Container(
                color: Colors.transparent,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    this.icon,
                    SizedBox(
                      height: SpacingValues.xxSmall,
                    ),
                    Text(
                      this.title,
                      style: TextThemes.homeScreenActionBarItem,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
