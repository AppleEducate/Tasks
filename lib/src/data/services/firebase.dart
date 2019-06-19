import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;

bool _ready = false;
void init() {
  if (!_ready) {
    // initializeApp(
    //   authDomain: "AUTH_DOMAIN",
    //   databaseURL: "DATABASE_URL",
    //   projectId: "PROJECT_ID",
    //   storageBucket: "STORAGE_BUCKET",
    //   messagingSenderId: "MESSAGE_SENDER_ID",
    // );
    _ready = true;
  }
}

Future<FirebaseUser> registerUser(String email, String password) async {
  init();
  if (email.isNotEmpty && password.isNotEmpty) {
    var trySignin = false;
    try {
      final _user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (_user != null) return _user;
    } catch (e) {
      if (e.code == "auth/email-already-in-use") {
        trySignin = true;
      } else {
        throw e;
      }
    }

    if (trySignin) {
      try {
        final _user = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        if (_user != null) return _user;
      } catch (e) {
        throw e;
      }
    }
  } else {
    throw "Please fill correct e-mail and password.";
  }
  throw 'Error Communicating with Firebase';
}

Future<FirebaseUser> startAsGuest() async {
  init();
  try {
    final _user = await auth.signInAnonymously();
    if (_user != null) return _user;
  } catch (e) {
    throw e.toString();
  }
  throw 'Error Communicating with Firebase';
}

Future forgotPassword(String email) async {
  init();
  try {
    await auth.sendPasswordResetEmail(email: email);
  } catch (e) {
    throw e.toString();
  }
}

Future logout() async {
  init();
  try {
    await auth.signOut();
  } catch (e) {
    throw e.toString();
  }
  throw 'Error Communicating with Firebase';
}

Future<FirebaseUser> checkUser() async {
  init();
  try {
    final _user = await auth.currentUser();
    if (_user != null) return _user;
  } catch (e) {
    throw e.toString();
  }
  throw 'Error Communicating with Firebase';
}

// Future<FirebaseUser> googleSignIn() async {
//   try {
//     final _user = await auth.signInWithCredential(GoogleAuthProvider());
//     if (_user != null) return _user;
//   } catch (e) {
//     throw e.toString();
//   }
//   throw 'Error Communicating with Firebase';
// }
