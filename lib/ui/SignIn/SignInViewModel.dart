import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:steam_wishlist_manager/ui/Wishlist/WishlistView.dart';
import 'package:steam_wishlist_manager/ui/Wishlist/WishlistViewModel.dart';
import '../../data/models/SWMUser.dart';
import '../../data/repositories/DatabaseRepo.dart';
import '../../data/repositories/FirebaseRepo.dart';
import '../CreateAccount/CreateAccountView.dart';
import '../CreateAccount/CreateAccountViewModel.dart';

class SignInViewModel extends ChangeNotifier {
  String? email, password, errorMsg;

  Future<void> signIn(BuildContext context) async {
    try {
      if (emailAndPasswordAreValid()) {
        UserCredential cred = await FirebaseRepo.signIn(email!, password!);
        if (cred.user != null) {
          SWMUser user = await DatabaseRepo.getUser(cred.user!.uid);
          WishlistViewModel wishlistVM = await WishlistViewModel.create(user);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WishlistView(wishlistVM: wishlistVM),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      errorMsg = "Incorrect email or password";
      notifyListeners();
    }
  }

  bool emailAndPasswordAreValid() {
    if (email == null || email!.isEmpty) {
      errorMsg = "Please enter an email";
    } else if (password == null || password!.isEmpty) {
      errorMsg = "Please enter a password";
    } else if (!RegExp(r'\w+@\w+\.\w+').hasMatch(email!)) {
      errorMsg = "Please enter a valid email";
    } else {
      errorMsg = null;
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
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
