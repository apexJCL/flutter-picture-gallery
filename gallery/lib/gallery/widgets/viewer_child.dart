import 'package:flutter/widgets.dart';

class ViewerChild extends StatelessWidget {
  final Widget child;
  final Offset focalPoint;
  final double scale;
  final bool shouldScale;

  const ViewerChild({
    Key key,
    @required this.child,
    this.scale = 1.0,
    this.shouldScale = false,
    this.focalPoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!shouldScale) {
      return child;
    }

    return Transform(
      transform: Matrix4.identity()
        ..translate(focalPoint.dx, focalPoint.dy)
        ..scale(scale),
      child: child,
    );
  }
}
