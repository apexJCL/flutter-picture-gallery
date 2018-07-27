import 'package:flutter/material.dart';
import 'package:flutter_widget_gallery/gallery/gallery.dart';

void main() => runApp(GalleryDemo());

class GalleryDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: PhotoViewer(),
    );
  }
}

class PhotoViewer extends StatelessWidget {
  final List<Widget> pictures;

  const PhotoViewer({Key key, this.pictures}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Gallery(
        children: pictures,
        activeItemColor: Theme.of(context).primaryColor,
        carouselBackgroundColor: Color(0xCCEAEAEA),
        carouselBackgroundItemColor: Color(0xFF000000),
        onChildTap: (index) => print('tapped on $index'),
        onChildLongPress: (index) => print('long press on $index'),
      ),
    );
  }
}
