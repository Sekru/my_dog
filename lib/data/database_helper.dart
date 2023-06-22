import 'dart:io';

import 'package:my_dog/data/dog_model.dart';
import 'package:my_dog/data/pet_food_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'dogs.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  void _createTables(Database db, int version) async {
    await db.execute(
      'CREATE TABLE dogs (id INTEGER PRIMARY KEY AUTOINCREMENT, imagePath TEXT, name TEXT, city TEXT, sex TEXT, birthDate DATETIME)',
    );
    await db.execute(
      'CREATE TABLE petfood (id INTEGER PRIMARY KEY AUTOINCREMENT, dogId INTEGER UNIQUE, name TEXT, max INTEGER, daily INTEGER, startDate DATETIME)',
    );
  }

  Future<int> insertDog(DogModel dogData) async {
    Database db = await database;
    return await db.insert('dogs', dogData.toMap());
  }

  Future<List<DogModel>> getDogs() async {
    Database db = await database;
    return (await db.query('dogs')).map((x) => DogModel.fromMap(x)).toList();
  }

  Future<int> inserPetFood(PetFoodModel pf) async {
    Database db = await database;
    return await db.insert('petfood', pf.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<PetFoodModel> getPetFood(int id) async {
    Database db = await database;
    return (await db.query('petfood', where: 'dogId = ?', whereArgs: [id]))
      .map((e) => PetFoodModel.fromMap(e)).first;
  }
}