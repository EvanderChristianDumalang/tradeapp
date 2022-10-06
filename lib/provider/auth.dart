import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:tradeapp/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyUser? _userFromFirebase(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  Future getCurrentUser() async {
    return _auth.currentUser;
  }

  String getCurrentUID() {
    return _auth.currentUser!.uid;
  }

  Stream<MyUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebase(user!);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebase(user!);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
