import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:steam_wishlist_manager/ui/SignIn/SignInView.dart';
import '../../data/models/Game.dart';
import '../../data/models/SWMUser.dart';
import '../../data/repositories/DatabaseRepo.dart';
import '../../data/repositories/FirebaseRepo.dart';
import '../../data/repositories/SteamRepo.dart';
import '../SignIn/SignInViewModel.dart';
import '../WishlistTile.dart';

class WishlistViewModel extends ChangeNotifier {
  WishlistViewModel({required this.user, required this.wishlistedGames});

  static Future<WishlistViewModel> create(SWMUser user) async {
    return WishlistViewModel(user: user, wishlistedGames: await DatabaseRepo.getWishlistedGames(user.uid));
  }

  final SWMUser user;
  List<Game> wishlistedGames;

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

  Future<List<ListTile>> search(SearchController controller) async {
    //search from steam
    var gameList = await SteamRepo.search(controller.text);

    //convert to list of widget
    List<ListTile> widgetList = List.empty(growable: true);
    for (var game in gameList) {
      widgetList.add(
        ListTile(
          title: Text(game.name),
          onTap: () {
            addGameToWishlist(game.gid);
            controller.closeView("");
          },
        ),
      );
    }
    return widgetList;
  }

  Future<void> addGameToWishlist(int gid) async {
    //try to get the game
    var game = await DatabaseRepo.getGame(gid);

    //if the game is not in already in our database, get it from steam and add it
    if (game == null) {
      game = await SteamRepo.getGame(gid);

      if (game != null) {
        DatabaseRepo.addGame(game);
      }
    }

    if (game != null) {
      //add the game to database wishlist
      DatabaseRepo.wishlistGame(user.uid, gid);

      //add game to local wishlist and refresh
      wishlistedGames.add(game);
      notifyListeners();
    }
  }

  Widget getWishlist() {
    if (wishlistedGames.isEmpty) {
      return Text(
        "You have no games in your wishlist. Try searching for some above.",
      );
    } else {
      List<WishlistTile> wishlistTiles = List.empty(growable: true);

      for (var game in wishlistedGames) {
        wishlistTiles.add(WishlistTile(game: game));
      }

      return Column(children: wishlistTiles);
    }
  }
}
