import 'package:flutter/material.dart';

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
              onSelected: (value){},
            )
        ],
      ),
      body: const Text("Hello world"),
    );
  }
}
