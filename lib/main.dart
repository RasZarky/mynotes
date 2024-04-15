import 'package:flutter/material.dart';
import 'package:mynotes/home_page.dart';
import 'package:mynotes/login_view.dart';
import 'package:mynotes/notes_view.dart';
import 'package:mynotes/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'My Notes',
    theme: ThemeData(      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      "/login/": (context) => const LoginPage(),
      "/register/": (context) => const Register(),
      "/notes/": (context) => const NotesView(),
    },
  ));
}