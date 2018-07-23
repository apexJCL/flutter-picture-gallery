import 'package:flutter/widgets.dart';
import 'package:gallery/gallery/widgets/thumbnail.picture.dart';

class ThumbnailsCarousel extends StatefulWidget {
  final List<ThumbnailPicture> pictures;

  const ThumbnailsCarousel({
    Key key,
    @required this.pictures,
  }) : super(key: key);

  @override
  _ImageCarouselState createState() => new _ImageCarouselState();
}

class _ImageCarouselState extends State<ThumbnailsCarousel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xCCFEFEFE),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widget.pictures,
        padding: const EdgeInsets.all(8.0),
      ),
    );
  }
}
