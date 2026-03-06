import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:steam_wishlist_manager/ui/Wishlist/WishlistView.dart';
import 'package:steam_wishlist_manager/ui/Wishlist/WishlistViewModel.dart';
import '../CreateAccount/CreateAccountView.dart';
import '../CreateAccount/CreateAccountViewModel.dart';

class SignInViewModel extends ChangeNotifier {
  String? email, password;

  Future<void> signIn(BuildContext context) async {
    try {
      UserCredential cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email ?? "",
        password: password ?? "",
      );
      if (cred.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WishlistView(wishlistVM: WishlistViewModel(user: cred.user!)),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      } else {
        debugPrint('FirebaseAuthException: ${e.message}');
      }
    } on Exception catch (e) {
      debugPrint('Caught error: ${e.toString()}');
    }
  }

  Future<void> goToCreateAccount(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreateAccountView(createAccountVM: CreateAccountViewModel()),
      ),
    );
  }

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }
}
