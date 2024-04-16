import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/routes.dart';

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main UI"),
        actions: [
            PopupMenuButton<MenuAction>(
                itemBuilder: (context){
                  return const [
                     PopupMenuItem<MenuAction>(
                      value:MenuAction.logout ,
                      child: Text("Log out"),
                    )
                  ];
                },
              onSelected: (value) async {
                  final logout = await showLogoutDialog(context);
                  log(logout.toString());
                  if(logout){
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        loginRoute,
                          (route) => false,);
                  }
              },
            )
        ],
      ),
      body: const Text("Hello world"),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context){
  return showDialog<bool>(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text("Log out"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.pop(context, true);
                },
                child: const Text("Log out"),),
            TextButton(
                onPressed: (){
                  Navigator.pop(context, false);
                },
                child: const Text("Cancel"),),
          ],
        );
      },).then((value) => value ?? false);
}