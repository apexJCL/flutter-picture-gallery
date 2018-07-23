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
          (index) => SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.network(
                  index.isOdd
                      ? 'https://picsum.photos/960/540?image=$index'
                      : 'https://picsum.photos/540/960?image=$index',
                ),
              ),
        ),
        onChildTap: (index) => print('tapped on $index'),
        onChildLongPress: (index) => print('long press on $index'),
      ),
    );
  }
}
