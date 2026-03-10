import 'package:steam_wishlist_manager/ui/Game/GameViewModel.dart';
import 'Game.dart';

class WishlistedGame {
  WishlistedGame({
    required this.game,
    required this.wishlistedat,
    required this.subscription
  });

  final Game game;
  final DateTime wishlistedat;
  Subscription? subscription;
}

class Subscription {
  Subscription({
    required this.type,
    required this.dollarthreshold,
    required this.percentthreshold
  });

  final SubscriptionType type;
  final int? dollarthreshold;
  final int? percentthreshold;
}