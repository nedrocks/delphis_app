import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';

class ModeratorPopupOption extends StatelessWidget {
  final Widget child;
  final String title;
  final String description;
  final VoidCallback onTap;

  const ModeratorPopupOption({
    Key key,
    @required this.title, 
    @required this.description, 
    @required this.onTap, 
    @required this.child
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final width = 120.0;
    return Container(
      height: width * 1.8,
      width: width,
      margin: EdgeInsets.all(SpacingValues.small),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color.fromRGBO(57, 58, 63, 0.4)
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: this.onTap,
          child: Container(
            padding: EdgeInsets.all(SpacingValues.medium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: width * 0.8,
                  child: Center(
                    child: child,
                  ),
                ),
                SizedBox(height: SpacingValues.medium),
                Text(
                  title,
                  style: TextThemes.goIncognitoButton,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: SpacingValues.small),
                Text(
                  description,
                  style: TextThemes.goIncognitoOptionAction.copyWith(),
                  textAlign: TextAlign.left,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

