import 'package:firebase/firebase.dart';
import 'package:flutter_web/material.dart';

import '../services/index.dart';

class AuthState extends ChangeNotifier {
  User _cred;
  String _error = '';
  bool _loading = false;

  String get error => _error;

  bool get isLoggedIn => _cred != null;

  User get cred => _cred;

  bool get isLoading => _loading;

  Future loginWithEmail(String email, String password) async {
    _error = '';
    _setLoading(true);

    try {
      _cred = await registerUser(email, password);
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future signInAsGuest() async {
    _error = '';
    _setLoading(true);

    try {
      _cred = await startAsGuest();
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  void logoutApp() {
    _cred = null;
    notifyListeners();
    logout();
  }

  Future sendForgotPassword(String email) async {
    await forgotPassword(email);
    notifyListeners();
  }

  void init() async {
    _error = '';
    _setLoading(true);

    try {
      _cred = await checkUser();
    } catch (e) {
      // _error = e.toString();
    }
    _setLoading(false);
  }

  void signInGoogle() async {
    _error = '';
    _setLoading(true);

    try {
      _cred = await googleSignIn();
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }
}
