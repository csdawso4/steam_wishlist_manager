import 'package:flutter/material.dart';
import 'SignInViewModel.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key, required this.signInVM});

  final SignInViewModel signInVM;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Email"),
              TextField(onChanged: (email) => {signInVM.setEmail(email)}),
              Text("Password"),
              TextField(
                onChanged: (password) => {signInVM.setPassword(password)},
              ),
              FloatingActionButton(
                onPressed: () => {signInVM.signIn(context)},
                child: Text("Sign In"),
              ),
              SizedBox(height: 20),
              Text("Don't have an account?"),
              FloatingActionButton(
                onPressed: () => {signInVM.goToCreateAccount(context)},
                child: Text("Create Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
