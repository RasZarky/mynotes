import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'login_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final  user = AuthService.firebase().currentsUser;
            if (user != null){
              if(user.isEmailVerified){
                return const NotesView();
              }else{
                return const VerifyEmailView();
              }
            }else {
              return const LoginPage();
            }
          default:
            return const CircularProgressIndicator();
        }

      },
    );
  }
}
