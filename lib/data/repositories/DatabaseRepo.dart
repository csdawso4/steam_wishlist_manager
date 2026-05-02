import 'package:flutter/cupertino.dart';
import 'package:steam_wishlist_manager/ui/Game/GameViewModel.dart';

import '../models/Game.dart';
import '../models/SWMUser.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../models/WishlistedGame.dart';

class DatabaseRepo {
  static final supabase = Supabase.instance.client;

  static Future<SWMUser> getUser(String uid) async {
    final response = await supabase.from("users").select("*").eq("uid", uid);
    Map<String, dynamic> userMap = response[0];
    return SWMUser(
      uid: userMap["uid"],
      email: userMap["email"],
      username: userMap["username"],
      fcmtoken: userMap["fcmtoken"],
    );
  }

  static Future<SWMUser> createUser(
    String uid,
    String email,
    String username,
  ) async {
    await supabase.from("users").insert({
      "uid": uid,
      "username": username,
      "email": email,
      "fcmtoken": null,
    });
    return SWMUser(uid: uid, email: email, username: username, fcmtoken: null);
  }

  static Future<void> updateFcmToken(String uid, String token) async {
    var junk = await supabase.from("users").update({"fcmtoken": token}).eq("uid", uid).select();
    debugPrint(junk.toString());
  }

  static Future<Game?> getGame(int gid) async {
    final response = await supabase.from("game").select("*").eq("gid", gid);
    try {
      if (response.isEmpty) {
        return null;
      }
      Map<String, dynamic> gameMap = response[0];
      return gameFromMap(gameMap);
    } on Exception catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  static Future<void> addGame(Game game) async {
    await supabase.from("game").insert({
      "gid": game.gid,
      "name": game.name,
      "shortdesc": game.shortdesc,
      "capsuleimgurl": game.capsuleimgurl,
      "currentprice": game.currentprice,
      "currentpercent": game.currentpercent,
      "bestrecordedprice": game.bestrecordedprice,
      "bestrecordedpercent": game.bestrecordedpercent,
    });
  }

  static Future<void> wishlistGame(String uid, int gid) async {
    await supabase.from("wishlist").insert({"uid": uid, "gid": gid});
  }

  static Future<void> unwishlistGame(String uid, int gid) async {
    await supabase.from("wishlist").delete().eq("uid", uid).eq("gid", gid);
  }

  static Future<List<WishlistedGame>> getWishlistedGames(String uid) async {
    final response = await supabase
        .from('wishlist')
        .select('''
    *,
    game (*),
    subscription (*)
  ''')
        .eq('uid', uid);

    List<WishlistedGame> wishlistedGames = List.empty(growable: true);

    for (var wishlistedGameMap in response) {
      wishlistedGames.add(wishlistedGameFromMap(wishlistedGameMap));
    }

    return wishlistedGames;
  }

  static Future<void> subscribe(
    String uid,
    int gid,
    int? dollarThreshold,
    int? percentThreshold,
  ) async {
    await supabase.from("subscription").insert({
      "uid": uid,
      "gid": gid,
      "dollarthreshold": dollarThreshold,
      "percentthreshold": percentThreshold,
    });
  }

  static Future<void> unsubscribe(
      String uid,
      int gid
      ) async {
    await supabase.from("subscription").delete().eq("uid", uid).eq("gid", gid);
  }

  static WishlistedGame wishlistedGameFromMap(
    Map<String, dynamic> wishlistedGameMap,
  ) {
    return WishlistedGame(
      game: gameFromMap(wishlistedGameMap["game"] as Map<String, dynamic>),
      wishlistedat: DateTime.parse(wishlistedGameMap["wishlistedat"]),
      subscription: subscriptionFromMap(
        wishlistedGameMap["subscription"] as Map<String, dynamic>?,
      )
    );
  }

  static Game gameFromMap(Map<String, dynamic> gameMap) {
    return Game(
      gid: gameMap["gid"],
      name: gameMap["name"],
      shortdesc: gameMap["shortdesc"],
      capsuleimgurl: gameMap["capsuleimgurl"],
      currentprice: gameMap["currentprice"],
      currentpercent: gameMap["currentpercent"],
      bestrecordedprice: gameMap["bestrecordedprice"],
      bestrecordedpercent: gameMap["bestrecordedpercent"],
    );
  }

  static Subscription? subscriptionFromMap(
    Map<String, dynamic>? subscriptionMap,
  ) {
    if (subscriptionMap == null) {
      return null;
    }

    int? dollarthreshold = subscriptionMap["dollarthreshold"];
    int? percentthreshold = subscriptionMap["percentthreshold"];
    SubscriptionType type = SubscriptionType.dollar;
    if (percentthreshold != null) {
      type = SubscriptionType.percent;
    }

    return Subscription(
      type: type,
      dollarthreshold: dollarthreshold,
      percentthreshold: percentthreshold,
    );
  }
}
