import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/login_view.dart';
import 'package:mynotes/verify_email_view.dart';

import 'firebase_options.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final  user = FirebaseAuth.instance.currentUser;
            if (user != null){
              if(user.emailVerified){
                log("Email verified");
              }else{
                return const VerifyEmailView();
              }
            }else {
              return const LoginPage();
            }
          // final user = FirebaseAuth.instance.currentUser;
          // if (user!.emailVerified){
          //   log("user verified");
          // } else{
          //   log("user not verified");
          //   return const VerifyEmailView();
          // }
            return const Text("Done");
          default:
            return const CircularProgressIndicator();
        }

      },
    );
  }
}
