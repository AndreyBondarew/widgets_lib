import 'package:flutter/material.dart';
import 'package:widgets/card_with_avatar/src/util/calculate_coordinate.dart';

import '../../const.dart';
import 'card_shape.dart';

class CardWithAvatar extends StatelessWidget {
  final CardSettings settings;

  const CardWithAvatar.fromSetting(this.settings, {Key? key}) : super(key: key);

  factory CardWithAvatar({
    Key? key,
    required Widget avatar,
    AvatarLocation avatarLocation = AvatarLocation.topLeft,
    EdgeInsets avatarOffset = const EdgeInsets.all(16),
    EdgeInsets avatarPadding = const EdgeInsets.all(4),
    Size avatarSize = const Size(90, 90),
    required Widget child,
    Widget? actionButton,
    ButtonLocation buttonLocation = ButtonLocation.rightDocked,
    double buttonIndented = 32,
    Size buttonSize = const Size(56, 56),
    EdgeInsets buttonPadding = const EdgeInsets.all(4),
    Color? backgroundColor,
    double elevation = 4.0,
    Radius radiusRect = const Radius.circular(4.0),
  }) {
    return CardWithAvatar.fromSetting(
      CardSettings(
        avatar: avatar,
        avatarLocation: avatarLocation,
        avatarOffset: avatarOffset,
        avatarPadding: avatarPadding,
        avatarSize: avatarSize,
        child: child,
        actionButton: actionButton,
        buttonLocation: buttonLocation,
        buttonIndented: buttonIndented,
        buttonSize: buttonSize,
        buttonPadding: buttonPadding,
        backgroundColor: backgroundColor,
        elevation: elevation,
        radiusRect: radiusRect,
      ),
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget> widgetBox = CalculateRectCoordinates.getWidgetsBox(settings: settings);
    return Stack(
      children: [
        Material(
          type: MaterialType.card,
          color: settings.backgroundColor,
          elevation: settings.elevation,
          shape: CardShape(settings),
          child: widgetBox['bodyBox'],
        ),
        //avatar
        widgetBox['avatarBox'] ?? Container(),
        widgetBox['buttonBox'] ?? Container(),
      ],
    );
  }
}

// ======================================================================================================

class CardSettings {
  final Widget avatar;
  final AvatarLocation avatarLocation;
  final EdgeInsets avatarOffset;
  final EdgeInsets avatarPadding;
  final Size avatarSize;
  final Widget child;
  final Widget? actionButton;
  final ButtonLocation buttonLocation;
  final Size buttonSize;
  final EdgeInsets buttonPadding;
  final double buttonIndented;
  final Color? backgroundColor;
  final double elevation;
  final Radius radiusRect;

  const CardSettings({
    required this.avatar,
    required this.avatarLocation,
    required this.avatarOffset,
    required this.avatarPadding,
    required this.avatarSize,
    required this.child,
    this.actionButton,
    required this.buttonLocation,
    required this.buttonSize,
    required this.buttonIndented,
    required this.buttonPadding,
    this.backgroundColor,
    required this.elevation,
    required this.radiusRect,
  });
}
