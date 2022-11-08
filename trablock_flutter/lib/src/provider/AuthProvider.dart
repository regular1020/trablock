import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider({auth, user}) : _auth = auth ?? FirebaseAuth.instance;

  User? _user;
  FirebaseAuth _auth;

  User? get user => _user;

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();


    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken
    );
    final authResult = await _auth.signInWithCredential(credential);
    _user = authResult.user;
  }
}