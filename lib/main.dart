import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:steam_wishlist_manager/ui/SignIn/SignInView.dart';
import 'package:steam_wishlist_manager/ui/SignIn/SignInViewModel.dart';
import 'package:steam_wishlist_manager/ui/Wishlist/WishlistView.dart';
import 'package:steam_wishlist_manager/ui/Wishlist/WishlistViewModel.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'https://omwsjuhjvdtrumtxrbdc.supabase.co',
    anonKey: 'sb_publishable_-iBJqiDtWU5phXmV4ZBJYA_R2cEVn_n',
  );
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    runApp(MyApp(user: user));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steam Wishlist Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: (user == null) ? SignInView(signInVM: SignInViewModel()) : WishlistView(wishlistVM: WishlistViewModel(user: user!)),
    );
  }
}
