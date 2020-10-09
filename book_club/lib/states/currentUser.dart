import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CurrentUser extends ChangeNotifier {
  String _uid;
  String _email;

  FirebaseAuth _auth = FirebaseAuth.instance;

  String get getUid => _uid;

  String get getEmail => _email;

  Future<String> signUpUser(String email, String password) async {
    String returnVal = "error";
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      returnVal = "success";
    } catch (e) {
      returnVal = e.message;
    }
    return returnVal;
  }

  Future<String> loginUserWithEmail(String email, String password) async {
    String returnVal = "error";
    try {
      AuthResult _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      _uid = _authResult.user.uid;
      _email = _authResult.user.email;
      returnVal = "success";
    } catch (e) {
      returnVal = e.message;
    }
    return returnVal;
  }
}
