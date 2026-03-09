import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepo {
  static final firebase = FirebaseAuth.instance;

  static Future<UserCredential> signIn(String email, String password) async {
    return await firebase.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<UserCredential> createAccount(String email, String password) async {
    return await firebase.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static signOut() async {
    firebase.signOut();
  }
}