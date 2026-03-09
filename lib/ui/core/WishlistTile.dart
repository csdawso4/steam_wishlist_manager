import 'package:flutter/material.dart';
import '../data/models/Game.dart';

class WishlistTile extends StatelessWidget {
  final Game game;

  WishlistTile({required this.game});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      child: Row(
        children: [
          Text(game.name),
          Text(game.currentprice.toString())
        ],
      ),
    );
  }
}
