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
              SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    controller: controller,
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    leading: FloatingActionButton(
                      onPressed: () {
                        controller.openView();
                      },
                      child: const Icon(Icons.search),
                    ),
                  );
                },
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                      return wishlistVM.search(controller);
                    },
              ),
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
