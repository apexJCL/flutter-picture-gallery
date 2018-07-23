import 'package:flutter/widgets.dart';

class ThumbnailItem extends StatefulWidget {
  final Widget child;
  final Function onPressed;
  final Color activeColor;
  final bool active;

  const ThumbnailItem({
    Key key,
    @required this.onPressed,
    @required this.child,
    @required this.activeColor,
    this.active = false,
  }) : super(key: key);

  @override
  ThumbnailItemState createState() {
    return new ThumbnailItemState();
  }
}

class ThumbnailItemState extends State<ThumbnailItem>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 128),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.active ? _controller.forward() : _controller.reverse();
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return AspectRatio(
          aspectRatio: 4.0 / 3.0,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
              onTap: widget.onPressed,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 4.0 * _controller.value,
                    color: widget.activeColor,
                  ),
                ),
                child: child,
              ),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
