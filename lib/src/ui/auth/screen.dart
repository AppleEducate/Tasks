import 'package:flutter_web/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/index.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _username = '';
  String _password = '';
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _justEmail = false;

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Builder(builder: (_) {
        if (_media.size.width > 720 && _media.size.height > 720) {
          return Container(
            child: Center(
              child: Container(
                width: 400,
                height: 800,
                child: Column(
                  children: <Widget>[
                    _buildImage(),
                    _buildForm(),
                  ],
                ),
              ),
            ),
          );
        }

        if (_media.size.width > _media.size.height) {
          return Container(
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: _buildImage(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildForm(),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: EdgeInsets.only(top: 40.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildImage(),
                _buildForm(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Container _buildForm() {
    return Container(
      child: Consumer<AuthState>(
        builder: (context, auth, child) => Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      initialValue: _username,
                      decoration: InputDecoration(labelText: 'Usename'),
                      autocorrect: false,
                      validator: (val) =>
                          val.isNotEmpty ? null : 'Username Required',
                      onSaved: (val) => _username = val,
                    ),
                    TextFormField(
                      initialValue: _password,
                      decoration: InputDecoration(labelText: 'Password'),
                      autocorrect: false,
                      obscureText: true,
                      validator: (val) => _justEmail || val.isNotEmpty
                          ? null
                          : 'Password Required',
                      onSaved: (val) => _password = val,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: RaisedButton(
                        child: Text('Login'),
                        onPressed: () async {
                          _justEmail = false;
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            await auth.loginWithEmail(_username, _password);
                            if (auth.error.isNotEmpty) {
                              _showMessage(auth.error);
                            }
                          }
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: FlatButton(
                        child: Text('Sign In As Guest'),
                        onPressed: () async {
                          await auth.signInAsGuest();
                          if (auth.error.isNotEmpty) {
                            _showMessage(auth.error);
                          }
                        },
                      ),
                    ),
                    if (auth.isLoading) ...[CircularProgressIndicator()],
                    if (auth.error.isNotEmpty) ...[
                      Container(
                        padding: EdgeInsets.only(top: 20.0),
                        child: RaisedButton(
                          child: Text('Forgot Password?'),
                          onPressed: () async {
                            _justEmail = true;
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              await auth.sendForgotPassword(_username);
                              _showMessage('Reset link sent to your email!');
                            }
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Image _buildImage() {
    return Image(
      width: 150.0,
      height: 150.0,
      image: AssetImage("images/icon.png"),
    );
  }

  void _showMessage(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }
}
