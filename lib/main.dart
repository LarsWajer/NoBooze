import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() {
  runApp(const NoBoozeApp());
}

class NoBoozeApp extends StatelessWidget {
  const NoBoozeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoBooze',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NoBoozeHomePage(title: 'NoBooze'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NoBoozeHomePage extends StatefulWidget {
  const NoBoozeHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _NoBoozeHomePageState createState() => _NoBoozeHomePageState();
}

class _NoBoozeHomePageState extends State<NoBoozeHomePage> {
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    _loadStreak();
  }

  Future<void> _loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final lastOpened = prefs.getString('lastOpened') ?? '';
    final today = DateTime.now().toIso8601String().split('T').first;

    if (lastOpened != today) {
      setState(() {
        _streak = (prefs.getInt('streak') ?? 0) + 1;
        prefs.setInt('streak', _streak);
        prefs.setString('lastOpened', today);
      });
    } else {
      setState(() {
        _streak = prefs.getInt('streak') ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to NoBooze!',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Text(
                'Streak: $_streak',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
