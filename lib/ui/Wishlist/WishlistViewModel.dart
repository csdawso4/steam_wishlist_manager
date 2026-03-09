import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:steam_wishlist_manager/ui/SignIn/SignInView.dart';
import '../../data/models/SWMUser.dart';
import '../../data/repositories/FirebaseRepo.dart';
import '../SignIn/SignInViewModel.dart';

class WishlistViewModel extends ChangeNotifier {
  WishlistViewModel({required this.user});

  final SWMUser user;

  Future<void> signOut(BuildContext context) async {
    try {
      FirebaseRepo.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInView(signInVM: SignInViewModel()),
        ),
      );
    } on FirebaseAuthException catch (e) {}
  }
}
