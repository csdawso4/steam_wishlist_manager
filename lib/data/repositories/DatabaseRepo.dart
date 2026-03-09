import 'package:flutter/cupertino.dart';

import '../models/Game.dart';
import '../models/SWMUser.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class DatabaseRepo {
  static final supabase = Supabase.instance.client;

  static Future<SWMUser> getUser(String uid) async {
    final response = await supabase.from("users").select("*").eq("uid", uid);
    Map<String, dynamic> userMap = response[0];
    return SWMUser(
      uid: userMap["uid"],
      email: userMap["email"],
      username: userMap["username"],
      firebaseIDs: List<String>.from(userMap["firebaseids"]),
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
      "firebaseids": [],
    });
    return SWMUser(uid: uid, email: email, username: username, firebaseIDs: []);
  }

  static Future<Game?> getGame(int gid) async {
    final response = await supabase.from("game").select("*").eq("gid", gid);
    try {
      if (response.isEmpty) {
        return null;
      }
      Map<String, dynamic> gameMap = response[0];
      return Game(
          gid: gameMap["gid"],
          name: gameMap["name"],
          shortdesc: gameMap["shortdesc"],
          capsuleimgurl: gameMap["capsuleimgurl"],
          currentprice: gameMap["currentprice"],
          currentpercent: gameMap["currentpercent"],
          bestrecordedprice: gameMap["bestrecordedprice"],
          bestrecordedpercent: gameMap["bestrecordedpercent"]
      );
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
      "bestrecordedpercent": game.bestrecordedpercent
    });
  }
}
