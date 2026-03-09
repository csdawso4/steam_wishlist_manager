import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:steam_wishlist_manager/ui/SignIn/SignInView.dart';
import '../../data/models/SWMUser.dart';
import '../../data/repositories/DatabaseRepo.dart';
import '../../data/repositories/FirebaseRepo.dart';
import '../../data/repositories/SteamRepo.dart';
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
            controller.closeView(game.name);
          }
        )
      );
    }
    return widgetList;
  }

  Future<void> addGameToWishlist(int gid) async {
    //try to get the game
    debugPrint("trying to get game from database");
    var game = await DatabaseRepo.getGame(gid);

    //if the game is not in already in our database, get it from steam and add it
    if (game == null) {
      debugPrint("game was not in database, trying to get from steam");
      game = await SteamRepo.getGame(gid);

      if (game != null) {
        debugPrint("game successfully got from steam, trying to add to database");
        DatabaseRepo.addGame(game);
      }
    }

    //add the game to database wishlist

    //add game to local wishlist and refresh

  }
}
