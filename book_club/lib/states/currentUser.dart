import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<String> loginUserWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    String returnVal = "error";
    try {
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
      AuthResult _authResult = await _auth.signInWithCredential(credential);

      _uid = _authResult.user.uid;
      _email = _authResult.user.email;
      returnVal = "success";
    } catch (e) {
      returnVal = e.message;
    }
    return returnVal;
  }
}
