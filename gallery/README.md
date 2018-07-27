# flutter_widget_gallery

Widget Gallery Viewer.

It's a gallery, where you can pass all the children you'd like to show.
It includes a bottom drawer to show the list of the children that are visible.

Implementation heavily relies on [Flutter Gallery Demo / Gridview](https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/grid_list_demo.dart) and [Fluttery Cards](https://github.com/matthew-carroll/flutter_ui_challenge_flip_carousel)

## Installing

**1. Edit your `pubspec.yaml` file:** 
```yaml
dependencies:
  flutter_widget_gallery: ^0.1.2
```

**2. Install the packages**

**3. Import the Gallery Widget**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_widget_gallery/gallery/gallery.dart';


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

```


## Example 2

```dart
import 'package:flutter/material.dart';

import 'gallery/gallery.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: Gallery(
        activeItemColor: Color(0xFF6A0AEA),
        backgroundColor: Color(0xFFF3F3F3),
        carouselBackgroundColor: Color(0xAAE3E3E3),
        children: List.generate<Widget>(
          10,
          (index) => Image.network(
                'https://picsum.photos/960/540?image=$index',
                fit: BoxFit.cover,
              ),
        ),
        onChildTap: (index) => print('tapped on $index'),
        onChildLongPress: (index) => print('long press on $index'),
      ),
    );
  }
}
```



