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
        //TODO fix this error: "Unhandled Exception: type 'List<dynamic>' is not a subtype of type 'List<String>'"
        firebaseIDs: List<String>.from(userMap["firebaseids"])
    );
  }

  static Future<SWMUser> createUser(String uid, String email, String username) async {
    await supabase.from("users").insert({"uid": uid, "username": username, "email": email, "firebaseids": []});
    return SWMUser(
        uid: uid,
        email: email,
        username: username,
        firebaseIDs: []
    );
  }
}