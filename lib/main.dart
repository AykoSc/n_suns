import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:n_suns/shared_prefs_helper.dart';
import 'package:n_suns/workout/workout.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'nSuns 5/3/1 LP',
      theme: ThemeData(
        // This is the theme of your application.
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'nSuns 5/3/1 LP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // Home page of app. Stateful (has a State object (defined below) that contains fields that affect how it looks).

  // This class is the configuration for the state. It holds the values (in this case the title) provided by the parent (in this case the App widget)
  // and used by the build method of the State. Fields in a Widget subclass are always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();

  int _week = 0;
  String _name = "";

  @override
  void initState() {
    super.initState();
    _loadWeek();
    _loadWorkoutName();
  }

  Future<void> _loadWeek() async {
    final week = await sharedPrefsHelper.loadWeek();
    setState(() {
      _week = week;
    });
  }

  Future<void> _loadWorkoutName() async {
  final name = await sharedPrefsHelper.loadWorkoutName();
  setState(() {
    _name = name;
  });
}

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done by the _incrementWeek method above.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        // Default: fit children horizontally, tries to be as tall as parent.
        children: <Widget>[
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 30,
                  shrinkWrap: true,
                  childAspectRatio: 5,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Text(
                      'Week',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      '$_week',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      'Workout',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      _name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                HorizontalButton(
                  color: Theme.of(context).colorScheme.primary,
                  text: 'Workout',
                  route: const WorkoutPage(),
                ),
                HorizontalButton(
                  color: Theme.of(context).colorScheme.primary,
                  text: 'Setup',
                  route: const WorkoutPage(),
                ),
                HorizontalButton(
                  color: Theme.of(context).colorScheme.primary,
                  text: 'History',
                  route: const WorkoutPage(),
                ),
              ],
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class HorizontalButton extends StatelessWidget {
  final Color color;
  final String text;
  final Widget route;

  const HorizontalButton({super.key, required this.color, required this.text, required this.route});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(color),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          minimumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 50)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => route),
          );
        },
        child: Text(text),
      ),
    );
  }
}