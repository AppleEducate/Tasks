import 'package:flutter_firebase_template/src/data/models/index.dart';
import 'package:flutter_web/material.dart';
import 'package:provider/provider.dart';

class MainListAppBar extends StatelessWidget {
  final String name;
  MainListAppBar({this.name});
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      expandedHeight: 85.0,
      floating: false,
      snap: false,
      pinned: true,
      actions: <Widget>[
        Consumer<AuthState>(
          builder: (context, auth, child) => FlatButton.icon(
                icon: Icon(
                  Icons.exit_to_app, 
                  color: Colors.black,
                ),
                label: Text('Logout'),
                onPressed: auth.logoutApp,
              ),
        ),
      ],
      elevation: 0.0,
      flexibleSpace: FlexibleSpaceBar(
        title: (name != "" && name != null)
            ? Text(
                name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w400,
                ),
              )
            : Text(""),
      ),
    );
  }
}
