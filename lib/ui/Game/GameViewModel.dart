import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:steam_wishlist_manager/ui/Wishlist/WishlistViewModel.dart';
import '../../data/models/WishlistedGame.dart';
import '../../data/repositories/DatabaseRepo.dart';
import '../Wishlist/WishlistView.dart';

class GameViewModel extends ChangeNotifier {
  WishlistedGame game;
  WishlistViewModel wishlistVM;
  SubscriptionType subscriptionType = SubscriptionType.dollar;
  String? dollarInput;
  String? percentInput;
  String? errorMsg;

  GameViewModel({required this.game, required this.wishlistVM});

  void goBackToWishlist(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WishlistView(wishlistVM: wishlistVM),
      ),
    );
  }

  void setSubscriptionType(SubscriptionType type) {
    subscriptionType = type;
    if (type == SubscriptionType.dollar) {
      percentInput = null;
    } else {
      dollarInput = null;
    }
    notifyListeners();
  }

  //TODO: clean this function up, pretty messy rn
  void subscribe() {
    debugPrint("dollarInput is $dollarInput");
    debugPrint("percentInput is $percentInput");

    if (subscriptionType == SubscriptionType.dollar) {
      if (dollarInput != null && RegExp(r'[0-9]+(.[0-9][0-9])?').hasMatch(dollarInput!)) {
        try {
          if (!dollarInput!.contains(".")) {
            dollarInput = "${dollarInput}00";
          }
          var dollarInt = int.parse(dollarInput!.replaceAll(".", ""));
          DatabaseRepo.subscribe(wishlistVM.user.uid, game.game.gid, dollarInt, null);
          game.subscription = Subscription(type: subscriptionType, dollarthreshold: dollarInt, percentthreshold: null);
          errorMsg = null;
          FirebaseMessaging.instance.requestPermission(provisional: false);
        } on Exception catch (e) {
          errorMsg = "Please enter a valid dollar amount";
        }
      } else {
        errorMsg = "Please enter a valid dollar amount";
      }
    } else {
      if (percentInput != null && RegExp(r'[0-9]+').hasMatch(percentInput!)) {
        try {
          var percentInt = int.parse(percentInput!);
          if (percentInt < 1 || percentInt > 100) {
            throw Exception("Invalid int for percent range");
          }
          DatabaseRepo.subscribe(wishlistVM.user.uid, game.game.gid, null, percentInt);
          game.subscription = Subscription(type: subscriptionType, dollarthreshold: null, percentthreshold: percentInt);
          errorMsg = null;
          FirebaseMessaging.instance.requestPermission(provisional: false);
        } on Exception catch (e) {
          errorMsg = "Please enter a valid percent: 1-100";
        }
      } else {
        errorMsg = "Please enter a valid percent: 1-100";
      }
    }
    notifyListeners();
  }

  void unsubscribe() {
    DatabaseRepo.unsubscribe(wishlistVM.user.uid, game.game.gid);
    game.subscription = null;
    notifyListeners();
  }
}

enum SubscriptionType {
  dollar,
  percent
}
