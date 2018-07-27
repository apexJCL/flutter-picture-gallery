# flutter_widget_gallery

Widget Gallery Viewer.

It's a gallery, where you can pass all the children you'd like to show.
It includes a bottom drawer to show the list of the children that are visible.

Implementation heavily relies on [Flutter Gallery Demo / Gridview](https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/grid_list_demo.dart) and [Fluttery Cards](https://github.com/matthew-carroll/flutter_ui_challenge_flip_carousel)

## Usage

To get started, add 'flutter_widget_gallery' [as a dependency in your `pubspec.yaml`](https://flutter.io/platform-plugins/)


Example

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



