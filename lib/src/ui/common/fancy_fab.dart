import 'package:flutter_web/material.dart';
import 'animated_icon.dart';

class FancyFab extends StatefulWidget {
  final VoidCallback detailsPressed, datePressed;
  final String tooltip;
  final IconData icon;

  FancyFab({this.detailsPressed, this.datePressed, this.tooltip, this.icon});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 55.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  bool detailsPressed = false;
  Widget details() {
    return Container(
      child: FloatingActionButton(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        mini: true,
        heroTag: "Details",
        onPressed: () {
          if (!detailsPressed) {
            widget.detailsPressed();
            detailsPressed = true;
          }
        },
        tooltip: 'Details',
        child: Icon(Icons.short_text,
            color: detailsPressed ? Colors.grey : Colors.blue),
      ),
    );
  }

  Widget calendar() {
    return Container(
      child: FloatingActionButton(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        mini: true,
        heroTag: "Calendar",
        onPressed: widget.datePressed,
        tooltip: 'Add Date',
        child: Icon(
          Icons.event_available,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        elevation: 0.0,
        mini: true,
        heroTag: "Toggle",
        backgroundColor: Colors.white,
        onPressed: animate,
        tooltip: 'Toggle',
        child: HighLightedIcon(
          controller: _animationController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        toggle(),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: details(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: calendar(),
        ),
      ],
    );
  }
}
