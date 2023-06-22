import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_dog/data/database_helper.dart';
import 'package:my_dog/data/dog_model.dart';
import 'package:my_dog/data/pet_food_model.dart';
import 'package:my_dog/shared/utility.dart';

class DogDashboardScreen extends StatefulWidget {
  final DogModel dog;
  const DogDashboardScreen({this.dog});

  @override
  _DogDashboardScreenState createState() => _DogDashboardScreenState();
}

class _DogDashboardScreenState extends State<DogDashboardScreen> {
  DatabaseHelper database;
  PetFoodModel pf;
  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.getPetFood(widget.dog.id).then((value) => setState(() {
      pf = value;
    }));
  }

  String getCurrentPetFood(PetFoodModel pf) {
    int diffrence = DateTime.now().difference(pf.startDate).inDays;
    return (diffrence * pf.daily - pf.max).abs().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SafeArea(
        child: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          staggeredTiles: [
            StaggeredTile.extent(2, 150),
            StaggeredTile.extent(1, 180),
            StaggeredTile.extent(1, 180),
          ],
          children: [
            buildImage(widget.dog),
            buildPetFood(widget.dog),
            buildCalendar(widget.dog),
          ],
        ),
      ),
    ));
  }

  Widget buildTile(Widget child, callback) {
    return Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(233, 101, 97, 0.8),
              borderRadius: BorderRadius.circular(12.0)),
          child: InkWell(child: child, onTap: callback),
        );
  }

  Widget buildPetFood(DogModel dog) {
    return buildTile(
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Material(
                  shape: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(MdiIcons.foodDrumstickOutline,
                        color: Color.fromRGBO(233, 101, 97, 1), size: 50.0),
                  )),
              const Padding(padding: EdgeInsets.only(bottom: 16.0)),
              Text(pf != null ? '${pf?.name}' : 'Uzupełnij karmę',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0)),
              pf != null ? Text('${getCurrentPetFood(pf)}/${pf?.max} gram',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0)) : Container(),
            ]),
      ),
      () => Navigator.pushNamed(context, '/pet-food', arguments: dog)
    );
  }

    Widget buildCalendar(DogModel dog) {
    return buildTile(
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Material(
                  shape: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(MdiIcons.calendar,
                        color: Color.fromRGBO(233, 101, 97, 1), size: 50.0),
                  )),
              const Padding(padding: EdgeInsets.only(bottom: 16.0)),
              Text('Kalendarz',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0)),
            ]),
      ),
      () => Navigator.pushNamed(context, '/calendar', arguments: dog)
    );
  }

  Widget buildImage(DogModel dog) {
    return Container(
      child: Card(
        color: Color.fromRGBO(233, 101, 97, 0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
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
                    buildTextRow(dog.sex, MdiIcons.genderMaleFemale),
                    buildTextRow(
                        Utility.calculateYear(dog.date), MdiIcons.cake),
                    buildTextRow(dog.city, Icons.location_on)
                  ],
                ),
              ),
            )
          ],
        ),
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
