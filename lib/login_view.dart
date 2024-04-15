import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        title: const Text("Login"),
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
                final userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                log(userCredential.toString());

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/notes/",
                      (route) => false,);

              } on FirebaseAuthException catch(e){
                if(e.code == "user-not-found"){
                  log("user not found");
                }else if(e.code == "wrong-password"){
                  log("wrong password");
                }
              }

            },
            child: const Text("Login"),
          ),
          TextButton(
              onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, "/register/", (route) => false);
              },
              child: const Text("Not registered? Click here to register"),
          ),
        ],
      ),
    );
  }
}