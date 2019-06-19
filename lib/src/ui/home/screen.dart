import 'package:flutter_web/material.dart';

import '../tasks/index.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return SafeArea(
      child: SizedBox(
        height: _size.height,
        width: _size.width,
        child: TasksHomePage(),
      ),
    );
  }
}
