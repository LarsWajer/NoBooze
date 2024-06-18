import 'package:flutter/material.dart';
import 'package:nobooze/Screens/login_screen.dart'; // Importeer de juiste login_screen.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoBooze',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        // Definieer hier je thema-instellingen
      ),
      home: const LoginScreen(), // Gebruik LoginScreen als home
      routes: {
        '/login': (context) => const LoginScreen(),
        // Voeg andere routes toe indien nodig
      },
    );
  }
}