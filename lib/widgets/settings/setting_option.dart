import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/widgets/circular_selection_checkmark/circular_selection_checkmark.dart';
import 'package:flutter/material.dart';

class SettingOption extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onSelected;
  final double height;
  final Widget leftSideContent;
  final Widget editContent;
  final VoidCallback onEdit;
  final Color selectedColor;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const SettingOption({
    @required this.isSelected,
    @required this.onSelected,
    @required this.height,
    @required this.leftSideContent,
    this.selectedColor = Colors.transparent,
    this.padding,
    this.margin,
    this.editContent,
    this.onEdit,
  })  : assert(editContent == null || onEdit != null,
            'If Edit content exists it requires an onEdit option'),
        super();

  @override
  Widget build(BuildContext context) {
    Widget rightHandSide = Container(width: 0, height: 0);
    if (this.editContent != null) {
      rightHandSide = InkWell(
        onTap: this.onEdit,
        child: this.editContent,
      );
    }
    return Container(
      margin : margin ?? EdgeInsets.symmetric(vertical: SpacingValues.xxSmall),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Material(
          color: isSelected ? this.selectedColor : Colors.transparent,
          child: Padding(
            padding: padding ?? EdgeInsets.all(SpacingValues.small),
            child: Row(children: [
              Expanded(
                  child: InkWell(
                      onTap: this.onSelected,
                      child: Row(children: [
                        CircularSelectionCheckmark(
                            radius: this.height * 0.3, isSelected: this.isSelected),
                        SizedBox(width: SpacingValues.small),
                        this.leftSideContent,
                      ]))),
              rightHandSide,
            ])),
          ),
      ),
    );
  }
}
