import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:steam_wishlist_manager/ui/SignIn/SignInView.dart';
import '../SignIn/SignInViewModel.dart';

class WishlistViewModel extends ChangeNotifier {
  WishlistViewModel({required this.user});

  final User user;

  Future<void> signOut(BuildContext context) async {
    try {
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInView(signInVM: SignInViewModel()),
        ),
      );
    } on FirebaseAuthException catch (e) {}
  }
}
