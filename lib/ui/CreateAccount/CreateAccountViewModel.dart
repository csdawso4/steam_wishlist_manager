import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../data/models/SWMUser.dart';
import '../../data/repositories/DatabaseRepo.dart';
import '../../data/repositories/FirebaseRepo.dart';
import '../Wishlist/WishlistView.dart';
import '../Wishlist/WishlistViewModel.dart';

class CreateAccountViewModel extends ChangeNotifier {
  String? username, email, password, errorMsg;

  Future<void> createAccount(BuildContext context) async {
    try {
      debugPrint("create account button pressed");
      if (emailPasswordUsernameAreValid()) {
        debugPrint("stuff was valid");
        UserCredential cred = await FirebaseRepo.createAccount(
          email!,
          password!,
        );
        if (cred.user != null) {
          SWMUser user = await DatabaseRepo.createUser(
            cred.user!.uid,
            email!,
            username!,
          );
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
      if (e.code == "email-already-in-use") {
        errorMsg = "Email is already in use";
      } else {
        errorMsg = "An error occured while trying to create your account";
        debugPrint("FirebaseAuthException: ${e.message}, ${e.code}");
      }
      notifyListeners();
    }
  }

  bool emailPasswordUsernameAreValid() {
    if (email == null || email!.isEmpty) {
      errorMsg = "Please enter an email";
    } else if (password == null || password!.isEmpty) {
      errorMsg = "Please enter a password";
    } else if (username == null || username!.isEmpty) {
      errorMsg = "Please enter a username";
    } else if (!RegExp(r'\w+@\w+\.\w+').hasMatch(email!)) {
      errorMsg = "Please enter a valid email";
    } else if (password!.length < 6 ||
        !password!.contains(RegExp(r'[A-Z]')) ||
        !password!.contains(RegExp(r'[a-z]')) ||
        !password!.contains(RegExp(r'[0-9]'))) {
      errorMsg =
          "Please enter a valid password: 6+ characters, at least one lowercase letter, one uppercase letter, and one number";
    } else if (username!.length < 3) {
      errorMsg = "Please enter a valid username: 3+ characters";
    } else {
      errorMsg = null;
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  void setUsername(String username) {
    this.username = username;
    notifyListeners();
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
