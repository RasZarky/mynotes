import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../utilities/show_error_dialog.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                hintText: "Enter email"
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
                hintText: "Enter password"
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
      
              try{
                await AuthService.firebase().createUser(
                    email: email,
                    password: password);
                await AuthService.firebase().sendEmailVerification();
                Navigator.pushNamed(context, verifyEmailRoute);
              } on WeakPasswordAuthException{
                log("weak password");
                await showErrorDialog(context, "weak password",);
              } on EmailAlreadyInUseAuthException{
                log("email already in use");
                await showErrorDialog(context, "Email already in use",);
              } on InvalidEmailAuthException{
                log("Invalid email");
                await showErrorDialog(context, "Invalid email",);
              } on GenericAuthException{
                await showErrorDialog(context, "Failed to register",);
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
              onPressed: (){
                Navigator.pushNamedAndRemoveUntil(
                    context, loginRoute, (route) => false);
              },
              child: const Text("Already registered? Login here"))
        ],
      ),
    );
  }
}