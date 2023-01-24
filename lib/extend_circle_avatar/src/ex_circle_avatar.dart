import 'dart:math';

import 'package:flutter/material.dart';

class ExtendCircleAvatar extends StatefulWidget {
  /*TODO интересный баг: при [radius] = 34 и [badgeRadius] = 10 при [visibleBadge] = true аватарка не отрисовывается. Пока оставлю AsIs.
  происходит это, когда центр малой окружности совпадает с точкой всех пересечений (_distanceA)*/
  final Widget? child;
  final Color? backgroundColor;
  final double radius;
  final VoidCallback? onTap;
  final Widget? badgeAddon;
  final double badgeRadius;
  final bool visibleBadge;
  final Duration animationDuration;

  const ExtendCircleAvatar({
    Key? key,
    this.child,
    this.backgroundColor = Colors.white,
    this.radius = 45,
    this.onTap,
    this.badgeAddon,
    this.badgeRadius = 12,
    this.visibleBadge = false,
    this.animationDuration = kThemeAnimationDuration,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ExtendCircleAvatar> with TickerProviderStateMixin {
  late AnimationController _shapeAnimationController;
  late Animation<double> _shapeAnimation;
  late AnimationController _colorAnimationController;
  late Animation<Color?> _colorAnimation;
  bool reverse = false;

  @override
  void initState() {
    super.initState();

    _shapeAnimationController = AnimationController(vsync: this, duration: widget.animationDuration);
    _shapeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _shapeAnimationController, curve: Curves.easeIn));
    _shapeAnimation.addListener(() {});
    if (widget.visibleBadge) {
      _shapeAnimationController.forward();
    }

    _colorAnimationController = AnimationController(vsync: this, duration: widget.animationDuration);
    _colorAnimation = ColorTween(begin: widget.backgroundColor, end: widget.backgroundColor)
        .animate(CurvedAnimation(parent: _colorAnimationController, curve: Curves.linear));
  }

  @override
  void dispose() {
    _shapeAnimationController.dispose();
    _colorAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ExtendCircleAvatar oldWidget) {
    if (oldWidget.backgroundColor != widget.backgroundColor) {
      _colorAnimation = ColorTween(begin: oldWidget.backgroundColor, end: widget.backgroundColor)
          .animate(CurvedAnimation(parent: _colorAnimationController, curve: Curves.ease));
      _colorAnimationController.reset();
      _colorAnimationController.forward();
    }
    if (oldWidget.visibleBadge != widget.visibleBadge) {
      if (widget.visibleBadge) {
        _shapeAnimationController.forward();
      } else {
        _shapeAnimationController.reverse();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: AnimatedBuilder(
        animation: _shapeAnimation,
        builder: (cnx, snap) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Stack(
              children: [
                SizedBox(
                  height: widget.radius * 2,
                  width: widget.radius * 2,
                  child: AnimatedBuilder(
                    animation: _colorAnimation,
                    builder: (context, snap) {
                      return Container(
                        decoration: ShapeDecoration(
                          color: _colorAnimation.value,
                          shape: _AvatarShape(
                            widget.badgeRadius,
                            _shapeAnimation.value * widget.badgeRadius,
                          ),
                        ),
                        child: Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            customBorder: _AvatarShape(
                              widget.badgeRadius,
                              _shapeAnimation.value * widget.badgeRadius,
                            ),
                            onTap: widget.onTap,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Padding(
                                padding: const EdgeInsets.all(2.5),
                                child: widget.child,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    height: widget.badgeRadius * 2,
                    width: widget.badgeRadius * 2,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Transform.scale(
                        scale: _shapeAnimation.value,
                        child: widget.badgeAddon,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AvatarShape extends ShapeBorder {
  final double aditionalControlRadius;
  final double currentControlRadius;

  const _AvatarShape(this.aditionalControlRadius, this.currentControlRadius);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Rect rectAdditionalControl = Rect.fromCenter(
        center: rect.bottomRight - Offset(aditionalControlRadius, aditionalControlRadius),
        width: currentControlRadius * 2,
        height: currentControlRadius * 2);

    _CircleIntersectionPointsData pointData = _calculatePoints(rect, rectAdditionalControl);

    /*return Path()
      ..addRect(rectAdditionalControl)
      ..addOval(rect);*/
    //return Path()..addOval(rectAdditionalControl); //
    //return Path()..addOval(rect);

    //print('pointA ${_pointData.pointA}, pointB ${_pointData.pointB}');

    if (!pointData.intersectionIsThere) {
      // || _pointData.pointA == _pointData.pointB) {
      return Path()..addOval(rect);
    }

    return Path()
      ..moveTo(pointData.pointA.dx, pointData.pointA.dy)
      ..arcToPoint(pointData.pointB, radius: Radius.circular(rect.width / 2), clockwise: false, largeArc: true)
      ..moveTo(pointData.pointB.dx, pointData.pointB.dy)
      ..arcToPoint(pointData.pointA,
          radius: Radius.circular(rectAdditionalControl.width / 2), clockwise: true, largeArc: pointData.isWithinCircle)
      ..fillType = PathFillType.evenOdd;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // TODO: implement paint
  }

  @override
  ShapeBorder scale(double t) => this;

  _CircleIntersectionPointsData _calculatePoints(Rect rect1, Rect rect2) {
    //http://www.pascal.hop.ru/cgi-bin/pages.pl?krug
    double distanceMain = sqrt(_sqr(rect1.center.dx - rect2.center.dx) + _sqr(rect2.center.dy - rect1.center.dy));

    if (distanceMain > (rect1.width / 2 + rect2.width / 2) || distanceMain < (rect1.width / 2 - rect2.width / 2).abs()) {
      return _CircleIntersectionPointsData(
        pointA: rect1.centerLeft,
        pointB: rect1.centerLeft,
        isWithinCircle: false,
        intersectionIsThere: false,
      );
    }
    double distanceA = (_sqr(rect2.width / 2) - _sqr(rect1.width / 2) + _sqr(distanceMain)) / (2 * distanceMain);
    double distanceB = distanceMain / (distanceMain - distanceA);
    //double heightHorde = sqrt(_sqr(rect2.width / 2) - _sqr(distanceA));
    double kOffset = (sqrt(_sqr(rect2.width / 2) - _sqr(distanceA))) / distanceA; //heightHorde / distanceA;

    double xIntersectionMain = (rect1.center.dx + (rect2.center.dx - rect1.center.dx) / distanceB);
    double yIntersectionMain = (rect1.center.dy + (rect2.center.dy - rect1.center.dy) / distanceB);

    return _CircleIntersectionPointsData(
      pointA: Offset(
        xIntersectionMain - (yIntersectionMain - rect2.center.dy) * kOffset,
        yIntersectionMain + (xIntersectionMain - rect2.center.dx) * kOffset,
      ),
      pointB: Offset(
        xIntersectionMain + (yIntersectionMain - rect2.center.dy) * kOffset,
        yIntersectionMain - (xIntersectionMain - rect2.center.dx) * kOffset,
      ),
      isWithinCircle: _sqr(rect2.center.dx - rect1.center.dx) + _sqr(rect2.center.dy - rect1.center.dy) <=
          _sqr(rect1.width / 2), //_distanceMain <= rect1.width / 2,
      intersectionIsThere: true,
    );

    /*
    //попытка решить баг - другой способ расчета координат пересечения.
    //http://delphimaster.net/view/14-1122121196
    double L = _sqr(rect1.center.dx - rect2.center.dx) + _sqr(rect1.center.dy - rect2.center.dy);
    double vt = _sqr(rect1.width / 2 + rect2.width / 2);
    if (L <= vt) {
      double xc = 1 / (2 * L);
      double t = (L - _sqr(rect2.width / 2) + _sqr(rect1.width / 2)) * xc;
      L = sqrt((vt - L) * (L - _sqr(rect1.width / 2 - rect2.width / 2))) * xc;
      xc = (rect2.center.dx - rect1.center.dx) * t + rect1.center.dx;
      double yc = (rect2.center.dy - rect1.center.dy) * t + rect1.center.dy;
      t = (rect2.center.dy - rect1.center.dy) * L;
      double xa = xc + t;
      double xb = xc - t;
      t = (rect1.center.dx - rect2.center.dx) * L;
      double ya = yc + t;
      double yb = yc - t;
      return (_CircleIntersectionPointsData(
          pointA: Offset(xa, ya), pointB: Offset(xb, yb), isWithinCircle: true, intersectionIsThere: xa != double.nan));
    } else {
      return (_CircleIntersectionPointsData(pointA: Offset.zero, pointB: Offset.zero, isWithinCircle: false, intersectionIsThere: false));
    }*/
  }

  double _sqr(double n) {
    return pow(n, 2) as double;
  }
}

class _CircleIntersectionPointsData {
  final Offset pointA;
  final Offset pointB;
  final bool isWithinCircle;
  final bool intersectionIsThere;

  _CircleIntersectionPointsData({
    required this.pointA,
    required this.pointB,
    required this.isWithinCircle,
    required this.intersectionIsThere,
  });
}
