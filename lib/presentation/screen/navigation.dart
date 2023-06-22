import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_dog/presentation/screen/calendar.dart';
import 'package:my_dog/presentation/screen/dog_list.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen();

  @override
  NavigationPage createState() => NavigationPage();
}

class NavigationPage extends State<NavigationScreen> {
  int index = 0;
  final List<Widget> children = [
    DogListScreen(),
    CalendarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: children[index],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Color.fromRGBO(233, 101, 97, 1),
        currentIndex: index,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Lista psów',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.calendar),
            label: 'Kalendarz',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int _index) {
    setState(() {
      index = _index;
    });
  }
}
