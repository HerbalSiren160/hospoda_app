// ignore_for_file: file_names

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'person.dart';

class PersonsDB {
  late Database _database;

  Future openDB() async {
    _database = await openDatabase(join(await getDatabasesPath(), "persons.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE persons(id INTEGER PRIMARY KEY autoincrement, name TEXT, wins INTEGER)",
      );
    });
    return _database;
  }

  Future<void> insertPerson(Person person) async {
    await openDB();

    await _database.insert(
      'persons',
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Person>> persons() async {
    await openDB();

    final List<Map<String, dynamic>> maps = await _database.query('persons');

    return List.generate(maps.length, (i) {
      return Person(
        id: maps[i]['id'],
        name: maps[i]['name'],
        wins: maps[i]['wins'],
      );
    });
  }

  Future<void> updatePerson(Person person) async {
    await openDB();

    await _database.update(
      'persons',
      person.toMap(),
      where: 'id = ?',
      whereArgs: [person.id],
    );
  }

  Future<void> deltePerson(int id) async {
    await openDB();

    await _database.delete(
      'persons',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
