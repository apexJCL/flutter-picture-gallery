import 'package:flutter/widgets.dart';

class PictureItem extends StatelessWidget {
  final Offset focalPoint;
  final ImageProvider src;
  final double scale;
  final bool shouldScale;

  const PictureItem({
    Key key,
    @required this.src,
    this.scale = 1.0,
    this.shouldScale = false,
    this.focalPoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!shouldScale) {
      return Image(image: src);
    }

    return Transform(
      transform: Matrix4.identity()
        ..translate(focalPoint.dx, focalPoint.dy)
        ..scale(scale),
      child: Image(
        image: src,
      ),
    );
  }
}
