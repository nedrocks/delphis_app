import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';

class SuperpowersPopupOption extends StatelessWidget {
  final Widget child;
  final String title;
  final String description;
  final VoidCallback onTap;

  const SuperpowersPopupOption(
      {Key key,
      @required this.title,
      @required this.description,
      @required this.onTap,
      @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
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
            margin: EdgeInsets.all(SpacingValues.medium),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: constraints.maxHeight,
                      height: constraints.maxHeight,
                      child: child,
                    );
                  },
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: SpacingValues.small,
                      horizontal: SpacingValues.medium,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              title,
                              style: TextThemes.superpowerOptionName,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              description,
                              style: TextThemes.superpowerOptionDescription,
                              textAlign: TextAlign.left,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
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
