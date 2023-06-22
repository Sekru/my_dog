import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_dog/data/database_helper.dart';
import 'package:my_dog/data/dog_model.dart';
import 'package:my_dog/data/pet_food_model.dart';

class PetFoodScreen extends StatefulWidget {
  final DogModel dog;
  const PetFoodScreen({this.dog});

  @override
  _PetFoodScreenState createState() => _PetFoodScreenState();
}

class _PetFoodScreenState extends State<PetFoodScreen> {
  DatabaseHelper database;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController max = TextEditingController();
  final TextEditingController daily = TextEditingController();
  DateTime startDate;

  @override
  void initState() {
    super.initState();
    database = DatabaseHelper.instance;
    DatabaseHelper.instance.getPetFood(widget.dog.id).then((value) => setState(() {
      name.text = value.name;
      max.text = value.max.toString();
      daily.text = value.daily.toString();
      startDate = value.startDate;
    }));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Dodaj / Uzupełnij karmę'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration:const InputDecoration(hintText: 'Wprowadź nazwę karmy'),
                  controller: name,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Wprowadź nazwę karmy';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: max,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration:
                      const InputDecoration(hintText: 'Waga produktu', suffixText: 'gram'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Waga produktu';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: daily,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration:
                      const InputDecoration(hintText: 'Dzienna ilość pokarmu', suffixText: 'gram'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Dzienna ilość pokarmu';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: ElevatedButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      child: startDate != null
                          ? Text(
                              'Karma rozpoczęta dnia: ${startDate?.day}/${startDate?.month}/${startDate?.year}')
                          : Text('Wybierz datę rozpoczęcia karmy'),
                    )),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: ElevatedButton(
                    child: const Text('Uzupełnij karmę'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        database
                            ?.inserPetFood(PetFoodModel(
                                dogId: widget.dog.id,
                                name: name.text,
                                max: int.parse(max.text),
                                daily: int.parse(daily.text),
                                startDate: startDate))
                            .then((value) =>
                                {Navigator.pushNamed(context, '/dog-dashboard', arguments: widget.dog)});
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
