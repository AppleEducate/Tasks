import 'package:flutter_web/material.dart';

class HighLightedIcon extends StatefulWidget {
  final double size;
  final AnimationController controller;

  HighLightedIcon({
    Key key,
    this.size = 24.0,
    this.controller,
  }) : super(key: key);
  @override
  State<HighLightedIcon> createState() {
    return new _AnimatedIconState();
  }
}

class _AnimatedIconState extends State<HighLightedIcon>
    with SingleTickerProviderStateMixin {
  final double dx = 4.0;
  Animation<Color> _buttonColor;
  bool isOpened = false;

  @override
  initState() {
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: widget.controller,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 20),
          firstChild: Icon(
            Icons.add_circle_outline,
            size: 24,
            color: _buttonColor.value,
          ),
          secondChild: Icon(
            Icons.close,
            size: 24,
            color: _buttonColor.value,
          ),
          crossFadeState: _buttonColor.value == Colors.blue
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
        ),
      ),
    );
  }
}
