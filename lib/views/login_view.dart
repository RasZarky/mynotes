import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import '../utilities/show_error_dialog.dart';

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
              try {
                await AuthService.firebase().login(
                    email: email, password: password);
                final user = AuthService
                    .firebase()
                    .currentsUser;
                if (user!.isEmailVerified) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    notesRoute,
                        (route) => false,);
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    verifyEmailRoute,
                        (route) => false,);
                }
              } on UserNotFoundAuthException{
                await showErrorDialog(context, "User not found",);
              } on WrongPasswordAuthException{
                await showErrorDialog(context, "wrong password",);
              } on GenericAuthException{
                await showErrorDialog(context, "Authentication Error",);
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
              onPressed: (){
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    registerRoute,
                      (route) => false,);
              },
              child: const Text("Not registered? Click here to register"),
          ),
        ],
      ),
    );
  }
}