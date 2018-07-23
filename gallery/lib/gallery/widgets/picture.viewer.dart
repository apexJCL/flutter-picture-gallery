import 'dart:ui';

import 'picture.dart';
import 'package:flutter/widgets.dart';

class PictureViewer extends StatefulWidget {
  final List<ImageProvider> pictures;

  const PictureViewer({
    Key key,
    @required this.pictures,
  }) : super(key: key);

  @override
  _PictureViewerState createState() => new _PictureViewerState();
}

class _PictureViewerState extends State<PictureViewer>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  // Position variables
  Offset initialDragPosition;
  double initialPercentValue;
  double finishDragStart;
  double finishDragEnd;
  double scrollPercent = 0.0;
  double currentScale = 1.0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )
      ..addStatusListener((status) {})
      ..addListener(() {
        setState(() {
          scrollPercent =
              lerpDouble(finishDragStart, finishDragEnd, controller.value);
          currentScale = 1.0;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pictures = [];

    for (var i = 0; i < widget.pictures.length; i++) {
      pictures.add(_buildPicture(context, i, widget.pictures[i]));
    }

    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        color: Color(0xFF000000),
        child: Stack(
          children: pictures,
        ),
      ),
      onHorizontalDragStart: _horizontalDragStart,
      onHorizontalDragEnd: _horizontalDragEnd,
      onHorizontalDragUpdate: _horizontalDragUpdate,
      onScaleStart: _scaleStart,
      onScaleEnd: _scaleEnd,
      onScaleUpdate: _scaleUpdate,
    );
  }

  Widget _buildPicture(BuildContext context, int index, ImageProvider source) {
    final double pictureScrollPercent =
        scrollPercent / (1 / widget.pictures.length);
    index == pictureScrollPercent ? print('index is $index') : null;
    return FractionalTranslation(
      translation: Offset(index - pictureScrollPercent, 0.0),
      child: PictureItem(
        src: source,
        shouldScale: index == pictureScrollPercent,
        scale: currentScale,
      ),
    );
  }

  void _horizontalDragStart(DragStartDetails details) {
    initialDragPosition = details.globalPosition;
    initialPercentValue = scrollPercent;
  }

  void _horizontalDragUpdate(DragUpdateDetails details) {
    final currentDrag = details.globalPosition;
    final dragDistance = currentDrag - initialDragPosition;
    final double singlePictureDragPercent =
        dragDistance.dx / context.size.width;
    setState(() {
      scrollPercent = (initialPercentValue +
              (-singlePictureDragPercent / widget.pictures.length))
          .clamp(0.0, 1.0 - (1 / widget.pictures.length));
    });
  }

  void _horizontalDragEnd(DragEndDetails details) {
    finishDragStart = scrollPercent;
    finishDragEnd = (scrollPercent * widget.pictures.length).round() /
        widget.pictures.length;
    controller.forward(from: 0.0);

    setState(() {
      initialDragPosition = null;
      initialPercentValue = null;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _scaleStart(ScaleStartDetails details) {}

  void _scaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      currentScale = details.scale.clamp(1.0, 4.0);
    });
  }

  void _scaleEnd(ScaleEndDetails details) {}
}
