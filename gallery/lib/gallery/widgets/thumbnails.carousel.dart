import 'package:flutter/widgets.dart';
import 'thumbnail.item.dart';

class ThumbnailsCarousel extends StatefulWidget {
  final List<ThumbnailItem> pictures;
  final Color backgroundColor;

  const ThumbnailsCarousel({
    Key key,
    @required this.pictures,
    this.backgroundColor = const Color(0xCCFEFEFE),
  }) : super(key: key);

  @override
  _ImageCarouselState createState() => new _ImageCarouselState();
}

class _ImageCarouselState extends State<ThumbnailsCarousel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widget.pictures,
        padding: const EdgeInsets.all(8.0),
      ),
    );
  }
}
