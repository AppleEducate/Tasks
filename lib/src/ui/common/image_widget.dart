import 'package:flutter_web/material.dart';

class ImageWidget extends StatelessWidget {
  final String image, title, subtitle;
  ImageWidget({this.subtitle, this.title, this.image});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 300.0,
            width: 300.0,
            child: Image.asset(
              image,
              fit: BoxFit.fitWidth,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.title.copyWith(fontSize: 25.0),
          ),
          Container(height: 5.0),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subtitle
                .copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
