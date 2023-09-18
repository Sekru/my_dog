import 'package:flutter/material.dart';
import 'package:my_dog/data/dog_model.dart';
import 'package:my_dog/presentation/screen/calendar.dart';
import 'package:my_dog/presentation/screen/dog_dashboard.dart';
import 'package:my_dog/presentation/screen/dog_profile.dart';
import 'package:my_dog/presentation/screen/navigation.dart';
import 'package:my_dog/presentation/screen/pet_food.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(233, 101, 97, 1)),
        useMaterial3: true,
      ),
      routes: {
        '/calendar': (context) => CalendarScreen(),
        '/dog-profile': (context) => DogProfileScreen(),
        '/dog-list': (context) => NavigationScreen(),
        '/dog-dashboard': (context) => DogDashboardScreen(dog: ModalRoute.of(context)?.settings.arguments as DogModel),
        '/pet-food': (context) => PetFoodScreen(dog: ModalRoute.of(context)?.settings.arguments as DogModel)
      },
      initialRoute: '/dog-list',
      home: const NavigationScreen(),
    );
  }
}
