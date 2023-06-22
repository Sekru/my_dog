import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalendarz'),
      ),
      body: Center(
        child: Text('To jest ekran kalendarza'),
      ),
    );
  }
}