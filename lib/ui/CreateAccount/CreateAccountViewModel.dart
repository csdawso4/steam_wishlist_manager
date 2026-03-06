import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../Wishlist/WishlistView.dart';
import '../Wishlist/WishlistViewModel.dart';

class CreateAccountViewModel extends ChangeNotifier {
  String? username, email, password;

  Future<void> createAccount(BuildContext context) async {
    try {
      UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email ?? "",
        password: password ?? "",
      );

      if (cred.user != null) {
        // create account with database
        final supabase = Supabase.instance.client;
        await supabase.from("users").insert({"userid": cred.user!.uid, "username": username, "email": email, "firebaseids": []});

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>
              WishlistView(wishlistVM: WishlistViewModel(user: cred.user!))),
        );
      }
    } on FirebaseAuthException catch (e) {}
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
