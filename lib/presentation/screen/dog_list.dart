import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_dog/data/database_helper.dart';
import 'package:my_dog/data/dog_model.dart';
import 'package:my_dog/shared/utility.dart';

class DogListScreen extends StatefulWidget {
  const DogListScreen();

  @override
  _DogListScreenState createState() => _DogListScreenState();
}

class _DogListScreenState extends State<DogListScreen> {
  DatabaseHelper database;
  List<DogModel> dogs = [];

  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.getDogs().then((value) => setState(() {
          dogs = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: dogs.isEmpty
          ? Center(
              child: Text('Dodaj swojego psa'),
            )
          : ListView.builder(
              itemCount: dogs.length,
              itemBuilder: (context, index) {
                final dog = dogs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/dog-dashboard',
                        arguments: dog);
                  },
                  child: Container(
                    height: 150,
                    child: Card(
                      color: Color.fromRGBO(233, 101, 97, 0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 40,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.file(
                                    File(dog.image),
                                    fit: BoxFit.cover,
                                  ))),
                          Expanded(
                            flex: 60,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildTextRow(dog.name, MdiIcons.dog),
                                  buildTextRow(
                                      dog.sex, MdiIcons.genderMaleFemale),
                                  buildTextRow(
                                      Utility.calculateYear(dog.date),
                                      MdiIcons.cake),
                                  buildTextRow(dog.city, Icons.location_on)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(233, 101, 97, 1),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, '/dog-profile');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildTextRow(String text, IconData icon) {
    return Expanded(
        flex: 25,
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 5.0),
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ));
  }
}
