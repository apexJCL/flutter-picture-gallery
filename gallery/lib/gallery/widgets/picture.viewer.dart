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

  // Scale and image panning
  Offset _currentOffset = Offset.zero;
  double _currentScale = 1.0;
  Offset _normalizedOffset;
  double _previousScale;

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
          if (_currentScale == 1.0) _currentOffset = Offset(0.0, 0.0);
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
    return FractionalTranslation(
      translation: Offset(index - pictureScrollPercent, 0.0),
      child: PictureItem(
        src: source,
        shouldScale: index == pictureScrollPercent,
        scale: _currentScale,
        focalPoint: _currentOffset,
      ),
    );
  }

  bool get scaling => _currentScale > 1.0;

  void _horizontalDragStart(DragStartDetails details) {
    if (scaling) {
      return;
    }
    initialDragPosition = details.globalPosition;
    initialPercentValue = scrollPercent;
  }

  void _horizontalDragUpdate(DragUpdateDetails details) {
    if (scaling) {
      return;
    }
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
    if (scaling) {
      return;
    }
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

  // Taken from Flutter / Gallery / Material / GridView

  // The maximum offset value is 0,0. If the size of this renderer's box is w,h
  // then the minimum offset value is w - _scale * w, h - _scale * h.
  Offset _clampOffset(Offset offset) {
    final Size size = context.size;
    final Offset minOffset =
        new Offset(size.width, size.height) * (1.0 - _currentScale);
    return new Offset(
        offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
  }

  void _scaleStart(ScaleStartDetails details) {
    setState(() {
      _previousScale = _currentScale;
      _normalizedOffset = (details.focalPoint - _currentOffset) / _currentScale;
    });
  }

  void _scaleUpdate(ScaleUpdateDetails details) {
    print('scaleUpdate called');
    setState(() {
      _currentScale = (_previousScale * details.scale).clamp(1.0, 4.0);
      // Ensure that image location under the focal point stays in the same place despite scaling.
      _currentOffset =
          _clampOffset(details.focalPoint - _normalizedOffset * _currentScale);
    });
  }

  void _scaleEnd(ScaleEndDetails details) {
    // Nothing yet
  }

// Taken from Flutter / Gallery / Material / GridView
}
