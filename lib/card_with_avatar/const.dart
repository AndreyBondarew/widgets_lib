//TODO replace enum to class
/*import 'package:widgets/widgets.dart';

class AvatarLocation{
  bool onLeftSide, onTopSide, onRightSide, onBottomSide,
  AvatarLocation._();

}

//Dead code*/
enum AvatarLocation {
  bottomLeftCoroner,
  leftBottom,
  leftCenter,
  leftTop,
  topLeftCoroner,
  topLeft,
  topCenter,
  topRight,
  topRightCoroner,
  rightTop,
  rightCenter,
  rightBottom,
  bottomRightCoroner,
  bottomRight,
  bottomCenter,
  bottomLeft,
}

enum ButtonLocation {
  leftDocked,
  leftFloat,
  centerDocked,
  centerFloat,
  rightDocked,
  rightFloat,
}
