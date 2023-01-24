import 'package:flutter/material.dart';
import 'package:widgets/card_with_avatar/const.dart';
import 'package:widgets/widgets.dart';

import '../widget/card.dart';
import 'grupping_side.dart';

//TODO replace Map to DTO
class CalculateRectCoordinates {
  static _IndentedData _getAvatarIndenteds(
    AvatarLocation location,
    Size avatarSize,
    EdgeInsets avatarOffset,
    bool useButton,
    Size buttonSize,
  ) {
    double? leftShift;
    double? topShift;
    double? rightShift;
    double? bottomShift;
    if (onLeftSide(location)) {
      leftShift = 0;
      if (location == AvatarLocation.leftTop) topShift = avatarOffset.top; //TODO - calculate this!!!!
      if (location == AvatarLocation.leftBottom) bottomShift = avatarOffset.bottom + (useButton ? buttonSize.height / 2 : 0);
      if (location == AvatarLocation.leftCenter) {
        topShift = 0;
        bottomShift = useButton ? buttonSize.height / 2 : 0;
      }
    }
    if (onTopSide(location)) {
      topShift = 0;
      if (location == AvatarLocation.topLeft) leftShift = avatarOffset.left;
      if (location == AvatarLocation.topRight) rightShift = avatarOffset.right;
      if (location == AvatarLocation.topCenter) leftShift = rightShift = 0;
    }
    if (onRightSide(location)) {
      rightShift = 0; //avatarSize.width;
      if (location == AvatarLocation.rightTop) topShift = avatarOffset.top;
      if (location == AvatarLocation.rightBottom) bottomShift = avatarOffset.bottom;
      if (location == AvatarLocation.rightCenter) {
        topShift = 0;
        bottomShift = useButton ? buttonSize.height / 2 : 0;
      }
    }
    if (onBottomSide(location)) {
      bottomShift = 0;
      if (location == AvatarLocation.bottomRight) rightShift = avatarOffset.right;
      if (location == AvatarLocation.bottomLeft) leftShift = avatarOffset.left;
      if (location == AvatarLocation.bottomCenter) leftShift = rightShift = 0;
    }
    return _IndentedData(leftShift: leftShift, topShift: topShift, rightShift: rightShift, bottomShift: bottomShift);
  }

  static _IndentedData _getBodyIndenteds(
    AvatarLocation location,
    Size avatarSize,
    bool useButton,
    Size buttonSize,
  ) {
    double leftShift = 0;
    double topShift = 0;
    double rightShifft = 0;
    double bottomShift = useButton ? buttonSize.height / 2 : 0;

    if (onLeftSide(location)) {
      leftShift = avatarSize.width / 2;
      rightShifft = 0;
    }

    if (onTopSide(location)) {
      topShift = avatarSize.height / 2;
      bottomShift = useButton ? buttonSize.height / 2 : 0;
    }

    if (onRightSide(location)) {
      rightShifft = avatarSize.width / 2;
      leftShift = 0;
    }

    if (onBottomSide(location)) {
      bottomShift = avatarSize.height / 2;
      topShift = 0;
    }

    return _IndentedData(leftShift: leftShift, topShift: topShift, rightShift: rightShifft, bottomShift: bottomShift);
  }

  static _IndentedData _getButtonIdenteds(
    ButtonLocation buttonLocation,
    Size buttonSize,
    double buttonIndented,
    AvatarLocation avatarLocation,
    Size avatarSize,
  ) {
    double? leftShift;
    double? rightShift;

    if (buttonLocation == ButtonLocation.leftDocked || buttonLocation == ButtonLocation.leftFloat) {
      leftShift = onLeftSide(avatarLocation) ? buttonIndented + avatarSize.width / 2 : buttonIndented;
    }
    if (buttonLocation == ButtonLocation.rightDocked || buttonLocation == ButtonLocation.rightFloat) {
      rightShift = onRightSide(avatarLocation) ? buttonIndented + avatarSize.width / 2 : buttonIndented;
    }
    if (buttonLocation == ButtonLocation.centerDocked || buttonLocation == ButtonLocation.centerFloat) {
      leftShift = rightShift = 0;
    }

    return _IndentedData(
      leftShift: leftShift,
      topShift: null,
      rightShift: rightShift,
      bottomShift: onBottomSide(avatarLocation) ? (avatarSize.height - buttonSize.height) / 2 : 0,
    );
  }

  static Rect _getAvatarRect(
    AvatarLocation location,
    Size avatarSize,
    EdgeInsets avatarOffset,
    Rect bodyRect,
    bool useButton,
    Size buttonSize,
  ) {
    _IndentedData _indentedData = _getAvatarIndenteds(
      location,
      avatarSize,
      avatarOffset,
      useButton,
      buttonSize,
    );

    Rect retRect = Rect.fromPoints(Offset.zero, Offset(avatarSize.width, avatarSize.height));

    double dx = onCenterX(location)
        ? bodyRect.center.dx - avatarSize.width / 2
        : _indentedData.leftShift ?? bodyRect.width - _indentedData.rightShift! - avatarSize.width / (onRightSide(location) ? 2 : 1);

    double dy = onCenterY(location)
        ? bodyRect.center.dy - avatarSize.height / 2
        : _indentedData.topShift ??
            (bodyRect.height - (_indentedData.bottomShift ?? 0)) -
                avatarSize.height / (onBottomSide(location) ? 2 : 1) +
                ((useButton && !onBottomSide(location)) ? buttonSize.height / 2 : 0);

    retRect = retRect.shift(Offset(dx, dy));
    return retRect;
  }

  static Rect _getBodyRect(Rect canvas, AvatarLocation location, Size avatarSize, bool useButton, Size buttonSize) {
    _IndentedData _indentedData = _getBodyIndenteds(location, avatarSize, useButton, buttonSize);
    return Rect.fromPoints(
      Offset(_indentedData.leftShift ?? 0, _indentedData.topShift ?? 0),
      Offset(
        canvas.width - (_indentedData.rightShift ?? 0),
        canvas.height - (_indentedData.bottomShift ?? 0),
      ),
    );
  }

  static Rect _getButtonRect(
    ButtonLocation buttonLocation,
    Size buttonSize,
    double buttonIndented,
    AvatarLocation avatarLocation,
    Size avatarSize,
    Rect bodyRect,
  ) {
    if ([ButtonLocation.rightFloat, ButtonLocation.centerFloat, ButtonLocation.leftFloat].contains(buttonLocation)) return Rect.zero;
    _IndentedData _indentedData = _getButtonIdenteds(buttonLocation, buttonSize, buttonIndented, avatarLocation, avatarSize);
    double dx = (buttonLocation == ButtonLocation.centerDocked
        ? bodyRect.bottomCenter.dx - buttonSize.width / 2
        : _indentedData.leftShift ?? bodyRect.width - (_indentedData.rightShift ?? 0) - buttonSize.width);
    Rect retRect = Rect.fromLTWH(
      dx,
      bodyRect.height - buttonSize.height - _indentedData.bottomShift!,
      buttonSize.width,
      buttonSize.height,
    );
    return retRect;
  }

  //======================================================================================
  //======================================================================================
  //======================================================================================

  static Map<String, Rect?> getRects(Rect canvasRect, CardSettings settings) {
    final Map<String, Rect?> retMap = {'bodyRect': null, 'avatarRect': null, 'buttonRect': null};

    final Rect bodyRect = _getBodyRect(
      canvasRect,
      settings.avatarLocation,
      settings.avatarSize,
      settings.actionButton != null,
      settings.buttonSize,
    );

    retMap['bodyRect'] = bodyRect;
    retMap['avatarRect'] = _getAvatarRect(
      settings.avatarLocation,
      settings.avatarSize,
      settings.avatarOffset,
      bodyRect,
      settings.actionButton != null,
      settings.buttonSize,
    );
    if (settings.actionButton != null) {
      //retMap['buttonRect'] = _calculateButtonRect(bodyRect, settings.buttonLocation, settings.buttonSize, settings.buttonIndented);
      retMap['buttonRect'] = _getButtonRect(
        settings.buttonLocation,
        settings.buttonSize,
        settings.buttonIndented,
        settings.avatarLocation,
        settings.avatarSize,
        canvasRect,
      );
    }

    return retMap;
  }

  //======================================================================================
  //======================================================================================
  //======================================================================================

  static Widget _getAvatarWidgetBox({
    required AvatarLocation location,
    required Size avatarSize,
    required EdgeInsets avatarOffset,
    required EdgeInsets avatarPadding,
    required Widget avatar,
    required bool useButton,
    required Size buttonSize,
  }) {
    _IndentedData _indentedData = _getAvatarIndenteds(location, avatarSize, avatarOffset, useButton, buttonSize);
    return Positioned(
      left: _indentedData.leftShift,
      top: _indentedData.topShift,
      right: _indentedData.rightShift,
      bottom: _indentedData.bottomShift,
      child: SizedBox(
        height: avatarSize.height,
        width: avatarSize.width,
        child: Center(child: avatar),
        /*child: Padding(
          padding: avatarPadding,
          child: Center(child: avatar),
        ),*/
      ),
    );
  }

  static Widget _getButonWidgetBox(
      {required Widget button,
      required Size buttonSize,
      required EdgeInsets buttonPadding,
      required double buttonIndented,
      required ButtonLocation buttonLocation,
      required AvatarLocation avatarLocation,
      required Size avatarSize}) {
    _IndentedData _indentedData = _getButtonIdenteds(buttonLocation, buttonSize, buttonIndented, avatarLocation, avatarSize);
    return Positioned(
        left: _indentedData.leftShift,
        top: _indentedData.topShift,
        right: _indentedData.rightShift,
        bottom: _indentedData.bottomShift,
        child: SizedBox(
          height: buttonSize.height,
          width: buttonSize.width,
          child: Padding(
            padding: buttonPadding,
            child: button,
          ),
        ));
  }

  static Widget _getBodyWidgetBox({
    required Widget? child,
    required AvatarLocation location,
    required Size avatarSize,
    required bool useButton,
    required Size buttonSize,
    required double rectRadius,
  }) {
    _IndentedData _indentedData = _getBodyIndenteds(location, avatarSize, useButton, buttonSize);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        (_indentedData.leftShift ?? 0) * 2 + rectRadius,
        (_indentedData.topShift ?? 0) * 2 + rectRadius,
        (_indentedData.rightShift ?? 0) * 2 + rectRadius,
        (_indentedData.bottomShift ?? 0) * 2 + rectRadius,
      ),
      child: child,
    );
  }

  static Map<String, Widget> getWidgetsBox({required CardSettings settings}) {
    Map<String, Widget> ret = {};
    ret['avatarBox'] = _getAvatarWidgetBox(
      location: settings.avatarLocation,
      avatarSize: settings.avatarSize,
      avatarOffset: settings.avatarOffset,
      avatarPadding: settings.avatarPadding,
      avatar: settings.avatar,
      useButton: settings.actionButton != null,
      buttonSize: settings.buttonSize,
    );
    ret['buttonBox'] = _getButonWidgetBox(
      button: settings.actionButton ?? Container(),
      buttonSize: settings.buttonSize,
      buttonPadding: settings.buttonPadding,
      buttonIndented: settings.buttonIndented,
      buttonLocation: settings.buttonLocation,
      avatarLocation: settings.avatarLocation,
      avatarSize: settings.avatarSize,
    );
    ret['bodyBox'] = _getBodyWidgetBox(
      child: settings.child,
      location: settings.avatarLocation,
      avatarSize: settings.avatarSize,
      useButton: settings.actionButton != null,
      buttonSize: settings.buttonSize,
      rectRadius: settings.radiusRect.x,
    );
    return ret;
  }
}

class _IndentedData {
  final double? leftShift;
  final double? topShift;
  final double? rightShift;
  final double? bottomShift;

  _IndentedData({
    this.leftShift,
    this.topShift,
    this.rightShift,
    this.bottomShift,
  });
}
