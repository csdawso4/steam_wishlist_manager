import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/Game.dart';
import '../models/GameSearchResult.dart';

class SteamRepo {
  static Future<List<GameSearchResult>> search(String searchTerm) async {
    final uri = Uri.https("store.steampowered.com", "/api/storesearch", {"term": searchTerm, "l": "english", "cc": "us"});
    final response = await http.get(uri);
    debugPrint("just made a call to steam api: search");

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      var jsonGameList = jsonResponse["items"] as List<dynamic>;
      List<GameSearchResult> gameSearchResultList = List.empty(growable: true);

      for (var jsonGame in jsonGameList) {
        var game = jsonGame as Map<String, dynamic>;
        String name = game["name"] as String;
        int gid = game["id"] as int;
        gameSearchResultList.add(GameSearchResult(gid: gid, name: name));
      }
      return gameSearchResultList;
    } else {
      return List.empty();
    }
  }

  static Future<Game?> getGame(int gid) async {
    final uri = Uri.https("store.steampowered.com", "/api/appdetails", {"appids": "$gid"});
    final response = await http.get(uri);
    debugPrint("just made a call to steam api: get game");

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      var jsonGame = jsonResponse["$gid"] as Map<String, dynamic>;
      var jsonGameData = jsonGame["data"] as Map<String, dynamic>;
      var jsonPriceOverview = jsonGameData["price_overview"] as Map<String, dynamic>;

      return Game(
        gid: gid,
        name: jsonGameData["name"] as String,
        shortdesc: jsonGameData["short_description"] as String,
        capsuleimgurl: jsonGameData["capsule_image"] as String,
        currentprice: jsonPriceOverview["final"] as int,
        currentpercent: jsonPriceOverview["discount_percent"] as int,
        bestrecordedprice: jsonPriceOverview["final"] as int,
        bestrecordedpercent: jsonPriceOverview["discount_percent"] as int
      );
    } else {
      return null;
    }
  }
}
