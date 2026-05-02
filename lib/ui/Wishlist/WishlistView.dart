import 'package:flutter/material.dart';
import 'WishlistViewModel.dart';
import '../../Utils.dart';
import '../../data/models/WishlistedGame.dart';
import '../Game/GameView.dart';
import '../Game/GameViewModel.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key, required this.wishlistVM});

  final WishlistViewModel wishlistVM;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: ListView(
              children: [
                Text("Welcome ${wishlistVM.user.username}!", textAlign: TextAlign.center,),
                SizedBox(height: 20),
                SearchAnchor(
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                      controller: controller,
                      onSubmitted: (submitted) {
                        controller.openView();
                      },
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
                ListenableBuilder(
                  listenable: wishlistVM,
                  builder: (BuildContext context, Widget? child) {
                    return Column(children: wishlistVM.getWishlist());
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
      ),
    );
  }
}

class WishlistTile extends StatelessWidget {
  final WishlistedGame game;
  final WishlistViewModel wishlistVM;

  WishlistTile({required this.game, required this.wishlistVM});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GameView(
                gameVM: GameViewModel(game: game, wishlistVM: wishlistVM),
              ),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (game.subscription != null)
                ? Icon(Icons.notifications)
                : Icon(Icons.notifications_none),
            Column(
              children: [
                Image.network(game.game.capsuleimgurl, scale: 1.1),
                Row(
                  children: [
                    if (game.game.currentpercent != 0)
                      Text("-${game.game.currentpercent}%"),
                    SizedBox(width: 10),
                    Text(Utils.intCentsToFomattedString(game.game.currentprice)),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                wishlistVM.removeGame(game.game.gid);
              },
              child: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
