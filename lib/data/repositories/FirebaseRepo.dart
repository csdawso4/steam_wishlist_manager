import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DatabaseRepo.dart';

class FirebaseRepo {
  static final firebaseAuth = FirebaseAuth.instance;
  static final firebaseMessaging = FirebaseMessaging.instance;

  static Future<UserCredential> signIn(String email, String password) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<UserCredential> createAccount(
    String email,
    String password,
  ) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static signOut() async {
    firebaseAuth.signOut();
  }

  static Future<void> initializeMessaging() async {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      debugPrint("setting latest_fcm_token to \"$token\" in sharedprefs");
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("latest_fcm_token", token);
      pushNewTokenIfNecessary(prefs);
    });
  }

  static Future<void> pushNewTokenIfNecessary(SharedPreferences prefs) async {
    var latestFcmToken = prefs.getString("latest_fcm_token");
    var currentUid = prefs.getString("current_uid");
    var currentUserFcmToken = prefs.getString("current_user_fcm_token");

    debugPrint("in pushNewTokenIfNecessary latestFcmToken was read as \"$latestFcmToken\" from sharedprefs");
    debugPrint("in pushNewTokenIfNecessary currentUid was read as \"$currentUid\" from sharedprefs");
    debugPrint("in pushNewTokenIfNecessary currentUserFcmToken was read as \"$currentUserFcmToken\" from sharedprefs");

    if (latestFcmToken != null && latestFcmToken.isNotEmpty && currentUid != null && currentUid.isNotEmpty) {
      if (latestFcmToken != currentUserFcmToken) {
        debugPrint("in pushNewTokenIfNecessary attempting to update token");
        await DatabaseRepo.updateFcmToken(currentUid, latestFcmToken);
        debugPrint("in pushNewTokenIfNecessary just finished updating token");
      }
    }
  }
}
