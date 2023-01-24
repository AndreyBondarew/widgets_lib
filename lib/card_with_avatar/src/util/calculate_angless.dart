import 'dart:math';

import '../../const.dart';
import 'grupping_side.dart';

//TODO replace Map to DTO
class CalculateAngless {
  static Map<String, double> calculateAngles(AvatarLocation location) {
    Map<String, double> retMap = {'startAngle': 0, 'endAngle': 0};

    if (onLeftSide(location, includeCoroner: false)) {
      retMap['startAngle'] = pi / 2;
      retMap['endAngle'] = pi;
    }

    if (onTopSide(location, includeCoroner: false)) {
      //retMap['startAngle'] = 0; //default
      retMap['endAngle'] = -pi;
    }

    if (onRightSide(location, includeCoroner: false)) {
      retMap['startAngle'] = -pi / 2;
      retMap['endAngle'] = pi;
    }

    if (onBottomSide(location, includeCoroner: false)) {
      //retMap['startAngle'] = 0; //default
      retMap['endAngle'] = pi;
    }

    if (location == AvatarLocation.topLeftCoroner) {
      //retMap['startAngle'] = 0; //default
      retMap['endAngle'] = -3 * pi / 2;
    }

    if (location == AvatarLocation.bottomLeftCoroner) {
      //retMap['startAngle'] = 0; //default
      retMap['endAngle'] = 3 * pi / 2;
    }

    if (location == AvatarLocation.bottomRightCoroner) {
      retMap['startAngle'] = -pi / 2;
      retMap['endAngle'] = 3 * pi / 2;
    }

    if (location == AvatarLocation.topRightCoroner) {
      retMap['startAngle'] = -pi;
      retMap['endAngle'] = 3 * pi / 2;
    }

    return retMap;
  }
}
