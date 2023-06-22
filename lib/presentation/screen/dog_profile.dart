import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_dog/data/database_helper.dart';
import 'package:my_dog/data/dog_model.dart';

class DogProfileScreen extends StatefulWidget {
  const DogProfileScreen();

  @override
  _DogProfileScreenState createState() => _DogProfileScreenState();
}

enum DogSex { male, female }

class _DogProfileScreenState extends State<DogProfileScreen> {
  DatabaseHelper database;
  final _formKey = GlobalKey<FormState>();
  File _image;
  DateTime birthDate;
  String name;
  DogSex sex = DogSex.male;
  String city;

  @override
  void initState() {
    super.initState();
    database = DatabaseHelper.instance;
  }

  Future _getImage() async {
    final pickedImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != birthDate) {
      setState(() {
        birthDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Tworzenie profilu psa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _getImage();
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: 180.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  _image,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Icon(
                                Icons.photo,
                                size: 80.0,
                                color: Colors.grey[600],
                              ),
                      )),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration:
                      const InputDecoration(hintText: 'Wprowadź imię psa'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Wprowadź imię psa';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    name = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration:
                      const InputDecoration(hintText: 'Miejsce zamieszkania'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Miejsce zamieszkania';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    city = value;
                  },
                ),
                const SizedBox(height: 16.0),
                Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(child: ListTile(
                          title: const Text('Pies'),
                          leading: Radio<DogSex>(
                            value: DogSex.male,
                            groupValue: sex,
                            onChanged: (DogSex value) {
                              setState(() {
                                sex = value;
                              });
                            },
                          ),
                        )),
                        Expanded(child: ListTile(
                          title: const Text('Suczka'),
                          leading: Radio<DogSex>(
                            value: DogSex.female,
                            groupValue: sex,
                            onChanged: (DogSex value) {
                              setState(() {
                                sex = value;
                              });
                            },
                          ),
                        )),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: ElevatedButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      child: birthDate != null
                          ? Text(
                              'Data urodzenia: ${birthDate?.day}/${birthDate?.month}/${birthDate?.year}')
                          : Text('Wybierz datę urodzenia'),
                    )),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: ElevatedButton(
                    child: const Text('Zapisz profil psa'),
                    onPressed: () {
                      if (_formKey.currentState.validate() &&
                          birthDate != null) {
                        database
                            ?.insertDog(DogModel(
                                image: _image?.path,
                                name: name,
                                date: birthDate,
                                city: city,
                                sex: sex.toString().split('.').last))
                            .then((value) =>
                                {Navigator.pushNamed(context, '/dog-list')});
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
