import 'package:flutter/material.dart';
import 'WishlistViewModel.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key, required this.wishlistVM});

  final WishlistViewModel wishlistVM;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome ${wishlistVM.user.username}!"),
              SizedBox(height: 20),
              Text("<WISHLIST>"),
              SizedBox(height: 20),
              FloatingActionButton(
                onPressed: () => {wishlistVM.signOut(context)},
                child: Text("Sign Out"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
