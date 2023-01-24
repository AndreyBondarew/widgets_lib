import 'package:flutter/material.dart';
import 'package:widgets/util/color_utils.dart';

class SelectableListItem extends StatelessWidget {
  final bool isSelected;
  final Widget? child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double shadowBlur;
  final double shadowSpread;
  final Offset shadowOffset;

  const SelectableListItem({
    super.key,
    required this.isSelected,
    this.child,
    this.onTap,
    this.onLongPress,
    this.shadowBlur = 3,
    this.shadowSpread = 2,
    this.shadowOffset = const Offset(2, 3),
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    CardTheme cardTheme = CardTheme.of(context);
    return AnimatedScale(
      scale: isSelected ? 1.005 : 1,
      duration: kThemeAnimationDuration,
      child: Padding(
        padding: EdgeInsets.fromLTRB(isSelected ? 2 : 3, 3, isSelected ? 2 : 3, 3), //all(3),
        child: AnimatedContainer(
          decoration: BoxDecoration(
            color: isSelected
                ? ColorUtils.similarColor(bg: theme.cardColor, c1: Colors.blue.shade100, c2: Colors.blueGrey.shade900)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              isSelected
                  ? BoxShadow(
                      color: cardTheme.shadowColor ?? theme.shadowColor,
                      blurRadius: shadowBlur,
                      spreadRadius: shadowSpread,
                      offset: shadowOffset,
                    )
                  : BoxShadow(
                      color: cardTheme.shadowColor ?? theme.shadowColor,
                      blurRadius: 0,
                      spreadRadius: 0,
                      offset: const Offset(0, 0),
                    ),
            ],
          ),
          duration: kThemeAnimationDuration,
          child: Material(
            type: MaterialType.transparency,
            child: Ink(
              child: InkWell(
                onTap: onTap,
                onLongPress: onLongPress,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
