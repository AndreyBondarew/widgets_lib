import 'package:widgets/widgets.dart';

//class CheckAvatarSide{
final List<AvatarLocation> _leftSide = [
  AvatarLocation.bottomLeftCoroner,
  AvatarLocation.leftBottom,
  AvatarLocation.leftCenter,
  AvatarLocation.leftTop,
  AvatarLocation.topLeftCoroner,
];

final List<AvatarLocation> _topSide = [
  AvatarLocation.topLeftCoroner,
  AvatarLocation.topLeft,
  AvatarLocation.topCenter,
  AvatarLocation.topRight,
  AvatarLocation.topRightCoroner,
];

final List<AvatarLocation> _rightSide = [
  AvatarLocation.topRightCoroner,
  AvatarLocation.rightTop,
  AvatarLocation.rightCenter,
  AvatarLocation.rightBottom,
  AvatarLocation.bottomRightCoroner,
];

final List<AvatarLocation> _bottomSide = [
  AvatarLocation.bottomRightCoroner,
  AvatarLocation.bottomRight,
  AvatarLocation.bottomCenter,
  AvatarLocation.bottomLeft,
  AvatarLocation.bottomLeftCoroner,
];

final List<AvatarLocation> _coroner = [
  AvatarLocation.bottomLeftCoroner,
  AvatarLocation.topLeftCoroner,
  AvatarLocation.topRightCoroner,
  AvatarLocation.bottomRightCoroner,
];

final List<AvatarLocation> _center = [
  AvatarLocation.leftCenter,
  AvatarLocation.topCenter,
  AvatarLocation.rightCenter,
  AvatarLocation.bottomCenter,
];

bool onLeftSide(AvatarLocation location, {bool includeCoroner = true}) => //leftSide.contains(location);
    includeCoroner ? _leftSide.contains(location) : (_leftSide.contains(location) && !_coroner.contains(location));

bool onTopSide(AvatarLocation location, {bool includeCoroner = true}) => //topSide.contains(location);
    includeCoroner ? _topSide.contains(location) : (_topSide.contains(location) && !_coroner.contains(location));

bool onRightSide(AvatarLocation location, {bool includeCoroner = true}) => //rightSide.contains(location);
    includeCoroner ? _rightSide.contains(location) : (_rightSide.contains(location) && !_coroner.contains(location));

bool onBottomSide(AvatarLocation location, {bool includeCoroner = true}) =>
    includeCoroner ? _bottomSide.contains(location) : (_bottomSide.contains(location) && !_coroner.contains(location));

bool onCoroner(AvatarLocation location) => _coroner.contains(location);

bool onCenter(AvatarLocation location) => _center.contains(location);

bool onCenterX(AvatarLocation location) => (onCenter(location) && (onTopSide(location) || onBottomSide(location)));

bool onCenterY(AvatarLocation location) => (onCenter(location) && (onLeftSide(location) || onRightSide(location)));

//}
