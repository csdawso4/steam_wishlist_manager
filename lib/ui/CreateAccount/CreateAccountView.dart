import 'package:flutter/material.dart';
import 'CreateAccountViewModel.dart';

class CreateAccountView extends StatelessWidget {
  const CreateAccountView({super.key, required this.createAccountVM});

  final CreateAccountViewModel createAccountVM;

  //TODO: add a back button to get back to signin
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Username"),
              TextField(
                onChanged: (username) => {
                  createAccountVM.setUsername(username),
                },
              ),
              Text("Email"),
              TextField(
                onChanged: (email) => {createAccountVM.setEmail(email)},
              ),
              Text("Password"),
              TextField(
                onChanged: (password) => {
                  createAccountVM.setPassword(password),
                },
              ),
              FloatingActionButton(
                onPressed: () => {createAccountVM.createAccount(context)},
                child: Text("Create Account"),
              ),
              ListenableBuilder(
                listenable: createAccountVM,
                builder: (BuildContext context, Widget? child) {
                  return Text(createAccountVM.errorMsg ?? "");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
