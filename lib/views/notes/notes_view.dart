import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';


class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {

  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentsUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).pushNamed(newNoteRoute);
              },
              icon: const Icon(Icons.add),
          ),
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
                    await AuthService.firebase().logout();
                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        loginRoute,
                          (route) => false,);
                  }
              },
            )
        ],
      ),
      body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.done:
                return StreamBuilder(
                    stream: _notesService.allNotes,
                    builder: (context, snapshot){
                      switch (snapshot.connectionState){
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return const Text("Waiting for all notes ...");
                        default:
                          return const CircularProgressIndicator();
                      }
                    }
                );
              default:
                return const CircularProgressIndicator();
            }
          },
      ),
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