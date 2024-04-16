import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Column(
        children: [
          const Text("Check your email to verify your account"),
          const Text("Didn't receive email? Press button to send email"),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text("send verification email"),
          ),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().logout();
                Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
              },
              child: const Text("Restart"),),
        ],
      ),
    );
  }
}
