import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nobooze/Services/auth_services.dart';
import 'package:nobooze/Services/globals.dart';
import 'package:nobooze/cards/InputCard.dart';
import 'dart:convert';
import 'dart:async';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import '../cards/scrollableCard.dart';
import '../cards/cardWidget.dart';
import '../cards/medalWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MoneySavedModel(),
      child: MaterialApp(
        title: 'Namer App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 83, 243, 145)),
        ),
        home: MyHomePage(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
        },
      ),
    );
  }
}

class MoneySavedModel with ChangeNotifier {
  double _moneySaved = double.parse(AuthServices.getUserInformation()['money_saved']);
  double get moneySaved => _moneySaved;

  String _motivation = AuthServices.getUserInformation()['original_motivation']; // Initieer de motivatie als een lege string
  String get motivation => _motivation;

  int _streak = AuthServices.getUserInformation()['streak']; // Initieer de motivatie als een lege string
  int get streak => _streak;



  Future<void> updateMoneySaved(double value) async {
    _moneySaved += value;
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse(baseURL + 'users/update/' + AuthServices.getUserInformation()['id'].toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, double>{
          'money_saved': _moneySaved,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update money saved');
      }
    } catch (e) {
      print('Error updating money saved: $e');
    }
  }

  Future<void> updateMotivation(String motivation) async {
    _motivation = motivation; // Update de lokale variabele voor motivatie
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse(baseURL + 'users/update/' + AuthServices.getUserInformation()['id'].toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'original_motivation': _motivation,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update money saved');
      }
    } catch (e) {
      print('Error updating money saved: $e');
    }
  }

    Future<void> deleteStreak() async {
    _streak = 0; // Update de lokale variabele voor motivatie

    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse(baseURL + 'users/update/' + AuthServices.getUserInformation()['id'].toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, int>{
          'streak': _streak,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update streak');
      }
    } catch (e) {
      print('Error updating streak: $e');
    }
  }

}



class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = StoryPage();
        break;
      case 2:
        page = MedalsPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.book),
                  label: Text('Favorites'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.emoji_events),
                  label: Text('Medals'),
                ),
                NavigationRailDestination(
  icon: ElevatedButton(
    onPressed: () async {
      try {
        // Haal de userId op van de ingelogde gebruiker
        final userId = AuthServices.getUserInformation()['id'].toString();

        // Doe de API-aanroep om de gebruiker te verwijderen
        final response = await http.delete(
          Uri.parse(baseURL + 'users/delete/' + userId),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        if (response.statusCode == 200) {
          // Succesvol verwijderd, navigeer naar /register (of een andere route)
          Navigator.pushNamed(context, '/register');
        } else {
          throw Exception('Failed to delete user');
        }
      } catch (e) {
        print('Error deleting user: $e');
        // Toon eventueel een foutmelding aan de gebruiker
      }
    },
    child: Text('Del acc'),
  ),
  label: SizedBox.shrink(),
),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/leaves.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: page,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'NoBooze',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(width: 10),
                        Image.asset(
                          'assets/images/logo.png',
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatefulWidget {
  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  final TextEditingController _moneyController = TextEditingController();
  final TextEditingController _motivationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var auth_service = AuthServices();

    return Consumer<MoneySavedModel>(
      builder: (context, moneySavedModel, child) {
        return Column(
          children: [
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: CardWidget(
                title: 'Streak:',
                value: moneySavedModel.streak.toString(),
                icon: Icons.local_fire_department_sharp,
                iconColor: Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () { 
                moneySavedModel.deleteStreak();
               }, child: Text('Gefaald..'),
               
                
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: CardWidget(
                title: 'Dry days:',
                value: AuthServices.getUserInformation()['dry_days'].toString(),
                icon: Icons.cloud,
                iconColor: Colors.blueGrey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: CardWidget(
                title: 'Money saved:',
                value: moneySavedModel.moneySaved.toString(),
                icon: Icons.attach_money,
                iconColor: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: InputCard(
                hintText: 'Enter saved money here...',
                inputType: InputType.numeric,
                onIntegerInput: (value) async {
                  await moneySavedModel.updateMoneySaved(value as double);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: ScrollableCardWidget(
                title: 'Motivation:',
                value: moneySavedModel.motivation,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: InputCard(
                hintText: 'Enter your motivation here...',
                inputType: InputType.text,
                onTextInput: (value) {
                  moneySavedModel.updateMotivation(value);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class StoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 60),
        FutureBuilder<List<dynamic>>(
          future: fetchStory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<dynamic>? story = snapshot.data;
              return Column(
                children: story!.map((story) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    child: ScrollableCardWidget(
                      title: story['name'],
                      value: story['story'],
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ],
    );
  }
}

class MedalsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 60),
        FutureBuilder<List<dynamic>>(
          future: fetchMedals(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<dynamic>? medals = snapshot.data;
              return Column(
                children: medals!.map((medal) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    child: MedalWidget(
                      title: medal['name'],
                      value: medal['description'],
                      icon: Icons.emoji_events,
                      iconColor: Colors.black,
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ],
    );
  }

  Future<List<dynamic>> fetchMedals() async {
    final response = await http.get(Uri.parse(baseURL +
        'users/showMedals/' +
        AuthServices.getUserInformation()['id'].toString()));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load medals');
    }
  }
}

Future<List<dynamic>> fetchStory() async {
  final response = await http.get(Uri.parse(baseURL + 'addictstories/all'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load story');
  }
}