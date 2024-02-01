import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static Future<void> createTables(Database database) async {
    await database.execute(
        """CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        data BLOB,
    name TEXT,
    age TEXT,
    classroom TEXT,
    div TEXT,
    email TEXT,
    phonenum TEXT,
    location TEXT
  )
  """);
  }

  static Future<Database> db() async {
    return openDatabase('students.db', version: 12,
        onCreate: (Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('students', orderBy: "id");
  }

  static Future<void> deleteAll() async {
    final db = await SQLHelper.db();
    db.delete('students');
  }

  static Future<int> createItems(
      Uint8List? imageData,
      String? name,
      String age,
      String classroom,
      String div,
      String email,
      String phonenum,
      String location) async {
    final db = await SQLHelper.db();

    final data = {
      'data': imageData,
      'name': name,
      'age': age,
      'classroom': classroom,
      'div': div,
      'email': email,
      'phonenum': phonenum,
      'location': location
    };

    final id = await db.insert('students', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("students", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<int> updateItem(
      int id,
      String name,
      String age,
      String classroom,
      String div,
      String email,
      String phonenum,
      String location) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'age': age,
      'classroom': classroom,
      'div': div,
      'email': email,
      'phonenum': phonenum,
      'location': location
    };

    final result =
        await db.update('students', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // static Future<Uint8List> getImage() async {
  //   final db = await SQLHelper.db();
  //   return db.query('students',);
  // }

  static Future<int> updateImageData(int id, Uint8List imageData) async {
    final db = await SQLHelper.db();
    final data = {
      'data': imageData,
    };

    final result = await db.update(
      'students',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );

    return result;
  }
}
