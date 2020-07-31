import 'package:flutter/material.dart';

enum HeaderOption { logout }

typedef HeaderOptionsCallback(HeaderOption option);

class HeaderOptionsButton extends StatelessWidget {
  final double diameter;
  final HeaderOptionsCallback onPressed;
  final bool isVertical;

  const HeaderOptionsButton({
    @required this.diameter,
    @required this.onPressed,
    this.isVertical = false,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<HeaderOption>(
      child: Container(
        width: this.diameter,
        height: this.diameter,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Color.fromRGBO(34, 35, 40, 0.0)),
        alignment: Alignment.center,
        child: Icon(
          this.isVertical ? Icons.more_vert : Icons.more_horiz,
          size: this.diameter * 0.8,
          color: Color.fromRGBO(200, 200, 207, 1.0),
          semanticLabel: "More...",
        ),
      ),
      onSelected: this.onPressed,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<HeaderOption>>[
        const PopupMenuItem<HeaderOption>(
          value: HeaderOption.logout,
          child: Text('Logout'),
        ),
      ],
    );
  }
}
