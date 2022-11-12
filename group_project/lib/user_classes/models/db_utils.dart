/*
* Author: Alessandro Prataviera
* */

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBUtils{
  static Future init() async{
    //set up the database
    var database = openDatabase(
      path.join(await getDatabasesPath(), 'genre_database.db'),
      onCreate: (db, version){
        db.execute(
            'CREATE TABLE genre_items(id INTEGER PRIMARY KEY, genre TEXT)'
        );
      },
      version: 1,
    );

    print("Created DB $database");
    return database;
  }
}