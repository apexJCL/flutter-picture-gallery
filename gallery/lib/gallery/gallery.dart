import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gallery/gallery/widgets/widgets.dart';

class Gallery extends StatefulWidget {
  final List<ImageProvider> pictures;
  final Color activeItemColor;

  const Gallery({
    Key key,
    @required this.pictures,
    @required this.activeItemColor,
  }) : super(key: key);

  @override
  _GalleryState createState() => new _GalleryState();
}

class _GalleryState extends State<Gallery> {
  ImageProvider activeProvider;
  bool carouselVisible = true;

  @override
  void initState() {
    super.initState();
    activeProvider = widget.pictures.first;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // AppBar, Carousel, stuff
        Align(
          child: CarouselDrawer(
            drawerChild: Carousel(
              pictures: widget.pictures
                  .map<CarouselPicture>((provider) => CarouselPicture(
                        activeColor: widget.activeItemColor,
                        active: activeProvider == provider,
                        imageProvider: provider,
                        onPressed: () {
                          setState(() {
                            activeProvider = provider;
                          });
                        },
                      ))
                  .toList(growable: false),
            ),
          ),
          alignment: Alignment.bottomCenter,
        ),
      ],
    );
  }
}
