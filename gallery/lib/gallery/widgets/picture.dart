import 'package:flutter/widgets.dart';

class PictureItem extends StatelessWidget {
  final ImageProvider src;
  final double scale;
  final bool shouldScale;

  const PictureItem({
    Key key,
    @required this.src,
    this.scale = 1.0,
    this.shouldScale = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: shouldScale ? scale : 1.0,
      child: Image(
        image: src,
      ),
    );
  }
}
