import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Namer App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 83, 243, 145)),
      ),
      home: MyHomePage(),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var person;

  Future<void> fetchPerson() async {
    final response =
        await http.get(Uri.parse('https://swapi.dev/api/people/1/'));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      person = jsonDecode(response.body);
      notifyListeners();
    } else {
      throw Exception('Failed to load person');
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
                      image: AssetImage(
                          'assets/images/leaves.jpg'), // Gebruik de juiste afbeelding
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 60), // Voeg ruimte toe tussen de balk en het eerste kaartje
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: CardWidget(
            title: 'Streak:',
            value: '5',
            icon: Icons.local_fire_department_sharp,
            iconColor: Colors.red,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: CardWidget(
            title: 'Dry days:',
            value: '2',
            icon: Icons.cloud,
            iconColor: Colors.blueGrey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: CardWidget(
            title: 'Money saved:',
            value: '€69420,00',
            icon: Icons.attach_money,
            iconColor: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: ScrollableCardWidget(
            title: 'Motivation Quote:',
            value:
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
          ),
        ),
      ],
    );
  }
}

class StoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 60), // Voeg ruimte toe tussen de balk en het eerste kaartje
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
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
        SizedBox(
            height: 60), // Voeg ruimte toe tussen de balk en het eerste kaartje
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
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
    final response =
        await http.get(Uri.parse('http://161.35.91.78/api/medals/all'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load medals');
    }
  }
}

Future<List<dynamic>> fetchStory() async {
  final response =
      await http.get(Uri.parse('http://161.35.91.78/api/addictstories/all'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load story');
  }
}

class CardWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const CardWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      height: 150.0,
      child: Card(
        elevation: 10,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 30.0,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 10),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MedalWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const MedalWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Card(
          elevation: 10,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: 30.0,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 10),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ScrollableCardWidget extends StatelessWidget {
  final String title;
  final String value;

  const ScrollableCardWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      height: 300.0,
      child: Card(
        elevation: 10,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
