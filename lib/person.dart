import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), '../db/persons.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE persons(id INTEGER PRIMARY KEY, name TEXT, wins INTEGER)',
      );
    },
    version: 1,
  );

  Future<void> insertPerson(Person person) async {
    final db = await database;

    await db.insert(
      'dogs',
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Person>> persons() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('dogs');

    return List.generate(maps.length, (i) {
      return Person(
        id: maps[i]['id'],
        name: maps[i]['name'],
        wins: maps[i]['wins'],
      );
    });
  }

  Future<void> updateDog(Person person) async {
    final db = await database;

    await db.update(
      'persons',
      person.toMap(),
      where: 'id = ?',
      whereArgs: [person.id],
    );
  }

  Future<void> deleteDog(int id) async {
    final db = await database;

    await db.delete(
      'perosns',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class Person {
  final int id;
  final String name;
  final int wins;

  Person({
    required this.id,
    required this.name,
    required this.wins,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'wins': wins,
    };
  }

  @override
  String toString() {
    return name;
  }
}
