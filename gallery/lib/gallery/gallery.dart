import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gallery/gallery/widgets/widgets.dart';

class Gallery extends StatefulWidget {
  /// List of children to be rendered on both the view
  /// and the drawer picker
  final List<Widget> children;
  final Color activeItemColor;

  const Gallery({
    Key key,
    @required this.activeItemColor,
    @required this.children,
  }) : super(key: key);

  @override
  _GalleryState createState() => new _GalleryState();
}

class _GalleryState extends State<Gallery> {
  Widget activeChild;
  bool carouselVisible = true;

  @override
  void initState() {
    super.initState();
    activeChild = widget.children.first;
  }

  int get activeIndex => widget.children.indexOf(activeChild);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Viewer(
          children: widget.children,
          activeIndex: activeIndex,
          onActiveChanged: (index) {
            setState(() {
              activeChild = widget.children[index];
            });
          },
        ),
        // AppBar, Carousel, stuff
        Align(
          child: ThumbnailsDrawer(
            child: ThumbnailsCarousel(
              pictures: widget.children
                  .map<ThumbnailItem>((child) => ThumbnailItem(
                        child: child,
                        activeColor: widget.activeItemColor,
                        active: activeChild == child,
                        onPressed: () {
                          setState(() {
                            activeChild = child;
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
