import 'package:flutter/material.dart';
import 'package:steam_wishlist_manager/ui/Wishlist/WishlistViewModel.dart';
import '../../data/models/WishlistedGame.dart';
import '../Game/GameView.dart';
import '../Game/GameViewModel.dart';
import 'Price.dart';

class WishlistTile extends StatelessWidget {
  final WishlistedGame game;
  final WishlistViewModel wishlistVM;

  WishlistTile({required this.game, required this.wishlistVM});

  //TODO: add an icon to represent if a subscription has been created for this game yet
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GameView(gameVM: GameViewModel(game: game, wishlistVM: wishlistVM)),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              (game.subscription != null) ? Icon(Icons.notifications) : Icon(Icons.notifications_none),
              SizedBox(width: 10),
              Image.network(game.game.capsuleimgurl),
              SizedBox(width: 10),
              Text(game.game.name),
            ],
          ),
          Row(
            children: [
              if (game.game.currentpercent != 0) Text("-${game.game.currentpercent}%"),
              SizedBox(width: 10),
              Price(price: game.game.currentprice),
              SizedBox(width: 10),
              ElevatedButton(onPressed: () {
                wishlistVM.removeGame(game.game.gid);
              }, child: Icon(Icons.delete))
            ],
          )
        ],
      ),
    );
  }
}
