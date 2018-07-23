import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'viewer.child.dart';

class Viewer extends StatefulWidget {
  /// Children to show on the viewer
  final List<Widget> children;

  /// Reports when the user changed to another child by swiping
  final Function(int) onActiveChanged;

  final ValueNotifier<int> activeNotifier;

  const Viewer({
    Key key,
    @required this.children,
    @required this.onActiveChanged,
    @required this.activeNotifier,
  }) : super(key: key);

  @override
  _PictureViewerState createState() => new _PictureViewerState();
}

class _PictureViewerState extends State<Viewer>
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
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          widget.onActiveChanged != null
              ? widget.onActiveChanged(currentIndex)
              : null;
        }
      })
      ..addListener(() {
        setState(() {
          scrollPercent =
              lerpDouble(finishDragStart, finishDragEnd, controller.value);
          if (_currentScale == 1.0) _currentOffset = Offset(0.0, 0.0);
        });
      });
    widget.activeNotifier.addListener(() {
      _currentScale = 1.0;
      _currentOffset = Offset.zero;
      finishDragStart = scrollPercent;
      finishDragEnd =
          (1 / widget.children.length) * widget.activeNotifier.value;
      controller.forward(from: 0.0);
    });
  }

  int get currentIndex =>
      (scrollPercent / (1 / widget.children.length)).round();

  @override
  Widget build(BuildContext context) {
    final List<Widget> pictures = [];

    for (var i = 0; i < widget.children.length; i++) {
      pictures.add(_buildChild(context, i, widget.children[i]));
    }

    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        color: Color(0xFF000000),
        child: Stack(
          children: pictures,
        ),
      ),
      onScaleStart: _scaleStart,
      onScaleEnd: _scaleEnd,
      onScaleUpdate: _scaleUpdate,
    );
  }

  Widget _buildChild(BuildContext context, int index, Widget child) {
    final double pictureScrollPercent =
        scrollPercent / (1 / widget.children.length);
    return FractionalTranslation(
      translation: Offset(index - pictureScrollPercent, 0.0),
      child: ViewerChild(
        child: child,
        shouldScale: index == currentIndex,
        scale: _currentScale,
        focalPoint: _currentOffset,
      ),
    );
  }

  bool get scaling => _currentScale > 1.0;

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
      initialDragPosition = details.focalPoint;
      initialPercentValue = scrollPercent;
      _previousScale = _currentScale;
      _normalizedOffset = (details.focalPoint - _currentOffset) / _currentScale;
    });
  }

  void _scaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _currentScale = (_previousScale * details.scale).clamp(1.0, 4.0);
      // Ensure that image location under the focal point stays in the same place despite scaling.
      _currentOffset =
          _clampOffset(details.focalPoint - _normalizedOffset * _currentScale);
    });
    if (!scaling) {
      // Drag
      final currentDrag = details.focalPoint;
      final dragDistance = currentDrag - initialDragPosition;
      final double singlePictureDragPercent =
          dragDistance.dx / context.size.width;
      setState(() {
        scrollPercent = (initialPercentValue +
                (-singlePictureDragPercent / widget.children.length))
            .clamp(0.0, 1.0 - (1 / widget.children.length));
      });
    }
  }

  void _scaleEnd(ScaleEndDetails details) {
    if (scaling) {
      return;
    }
    finishDragStart = scrollPercent;
    finishDragEnd = (scrollPercent * widget.children.length).round() /
        widget.children.length;
    controller.forward(from: 0.0);

    setState(() {
      initialDragPosition = null;
      initialPercentValue = null;
    });
  }

// Taken from Flutter / Gallery / Material / GridView
}
