import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';

class SuperpowersOption extends StatelessWidget {
  final Widget child;
  final String title;
  final String description;
  final VoidCallback onTap;

  const SuperpowersOption(
      {Key key,
      @required this.title,
      @required this.description,
      @required this.onTap,
      @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = 120.0;
    return Container(
      height: height,
      margin: EdgeInsets.all(SpacingValues.small),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color.fromRGBO(57, 58, 63, 0.4),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        child: InkWell(
          onTap: this.onTap,
          child: Container(
            padding: EdgeInsets.all(SpacingValues.medium),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: height * 0.8,
                  child: Center(
                    child: child,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: SpacingValues.small,
                      horizontal: SpacingValues.medium,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            title,
                            style: TextThemes.goIncognitoButton,
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: SpacingValues.small),
                        Flexible(
                          child: Text(
                            description,
                            style: TextThemes.goIncognitoSubheader,
                            textAlign: TextAlign.left,
                            maxLines: 4,
                            //overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
