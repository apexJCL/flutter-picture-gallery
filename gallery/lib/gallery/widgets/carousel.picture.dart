import 'package:flutter/widgets.dart';

class CarouselPicture extends StatelessWidget {
  final ImageProvider imageProvider;
  final Function onPressed;
  final Color activeColor;
  final bool active;

  const CarouselPicture({
    Key key,
    @required this.onPressed,
    @required this.imageProvider,
    @required this.activeColor,
    this.active = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4.0 / 3.0,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: active ? 4.0 : 0.0,
                color: activeColor,
              ),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
