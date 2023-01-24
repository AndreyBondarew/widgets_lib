import 'dart:math';

import 'package:flutter/material.dart';
import 'package:widgets/card_with_avatar/src/util/calculate_coordinate.dart';
import 'package:widgets/card_with_avatar/src/util/grupping_side.dart';
import 'package:widgets/card_with_avatar/src/widget/card.dart';

import '../util/calculate_angless.dart';

class CardShape extends ShapeBorder {
  final CardSettings settings;
  final double contentPadding = 8.0;

  const CardShape(this.settings);

  @override
  EdgeInsetsGeometry get dimensions {
    /*double leftPadding = 0;
    double rightPadding = 0;
    double topPadding = 0;
    double bottomPadding = 0;*/

    /* if (onLeftSide(settings.avatarLocation, includeCoroner: false)) {
      leftPadding = settings.avatarSize.width / 2 + contentPadding;
    }

    if (onTopSide(settings.avatarLocation)) {
      topPadding = settings.avatarSize.height / 2 + contentPadding;
    }

    if (onRightSide(settings.avatarLocation, includeCoroner: false)) {
      rightPadding = settings.avatarSize.width / 2 + contentPadding;
    }

    if (onBottomSide(settings.avatarLocation)) {
      bottomPadding = settings.avatarSize.height / 2 + contentPadding;
    }*/

    return EdgeInsets.all(0); //fromLTRB(leftPadding, topPadding, rightPadding, bottomPadding);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Map<String, Rect?> rectMaps = CalculateRectCoordinates.getRects(rect, settings);

    Path path = Path();
    if (rectMaps['bodyRect'] != null) {
      path.addRRect(RRect.fromRectAndRadius(rectMaps['bodyRect']!, settings.radiusRect));
    }
    if (rectMaps['avatarRect'] != null) {
      Map<String, double> angleMaps = CalculateAngless.calculateAngles(settings.avatarLocation);
      path.addArc(rectMaps['avatarRect']!, angleMaps['startAngle']!, angleMaps['endAngle']!);
      if (onCoroner(settings.avatarLocation)) {
        path.lineTo(rectMaps['avatarRect']!.center.dx, rectMaps['avatarRect']!.center.dy);
      }
    }
    if (rectMaps['buttonRect'] != null) {
      path.addArc(rectMaps['buttonRect']!, 0, -pi);
    }

    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // TODO: implement paint
  }

  @override
  ShapeBorder scale(double t) => this;
}
