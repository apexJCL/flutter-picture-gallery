import 'package:flutter/widgets.dart';

class ThumbnailsDrawer extends StatefulWidget {
  final Widget child;
  final Function(bool open) onVisibilityChanged;

  const ThumbnailsDrawer({
    Key key,
    this.onVisibilityChanged,
    @required this.child,
  }) : super(key: key);

  @override
  _CarouselState createState() => new _CarouselState();
}

class _CarouselState extends State<ThumbnailsDrawer>
    with TickerProviderStateMixin {
  AnimationController controller;

  // Status
  DrawerStatus drawerStatus;

  // Position variables
  Offset initialDragPosition;
  double initialPercentValue;
  double finishDragStart;
  double finishDragEnd;
  bool visible;

  @override
  void initState() {
    super.initState();
    drawerStatus = DrawerStatus.COMPACT;
    visible = true;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          setState(() {
            finishDragStart = null;
            finishDragEnd = null;
            visible = controller.value == 1.0;
          });
          widget.onVisibilityChanged != null
              ? widget.onVisibilityChanged(visible)
              : false;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: FractionallySizedBox(
          heightFactor: 0.25,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.90,
              child: widget.child,
            ),
          ),
        ),
        onVerticalDragStart: _verticalDragStart,
        onVerticalDragUpdate: _verticalDragUpdate,
        onVerticalDragEnd: _verticalDragEnd,
        onVerticalDragCancel: _verticalDragCancel,
      ),
      animation: controller,
      builder: (BuildContext context, Widget child) => FractionalTranslation(
            translation: Offset(0.0, 0.9 * controller.value),
            child: child,
          ),
    );
  }

  void _verticalDragStart(DragStartDetails details) {
    initialDragPosition = details.globalPosition;
    initialPercentValue = controller.value;
  }

  void _verticalDragUpdate(DragUpdateDetails details) {
    final currentDrag = details.globalPosition;
    final dragDistance = currentDrag - initialDragPosition;
    controller.value =
        initialPercentValue + (dragDistance.dy / context.size.height);
  }

  void _verticalDragEnd(DragEndDetails details) {
    finishDragStart = controller.value;
    finishDragEnd =
        (controller.value * context.size.height).round() / context.size.height;
    print(finishDragEnd);
    finishDragEnd < 0.5 ? controller.reverse() : controller.forward();
    setState(() {
      initialDragPosition = null;
      initialPercentValue = null;
    });
  }

  void _verticalDragCancel() {}

  show() {
    controller.reverse();
  }

  hide() {
    controller.forward();
  }

  toggle() {
    visible ? controller.forward() : controller.reverse();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

/// TODO: implement this :P
enum DrawerStatus {
  /// Carousel is offscreen
  HIDDEN,

  /// Carousel is on the bottom, showing only a single row, horizontal scroll
  COMPACT,

  /// Carousel is on top of the content, vertical scrolling and possible a grid.
  FULLSCREEN,
}
