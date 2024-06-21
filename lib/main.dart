import 'package:flutter/material.dart';
// Importeer de juiste login_screen.dart
import 'package:nobooze/Screens/register_screen.dart';

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
      home: const RegisterScreen(), // Gebruik LoginScreen als home
      routes: {
        '/register': (context) => const RegisterScreen(),
        //'/login':
        // Voeg andere routes toe indien nodig
      },
    );
  }
}