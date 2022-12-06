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
//playlist_items
//playlist_database.db
class SongDBUtils {
  static Future init() async{
    //set up the database
    var database = openDatabase(
      path.join(await getDatabasesPath(), 'playlist_songs_database.db'),
      onCreate: (db, version){
        db.execute(
            'CREATE TABLE playlist_songs(id INTEGER PRIMARY KEY, name TEXT, artist TEXT, duration TEXT, link TEXT)'
        );
      },
      version: 1,
    );

    print("Created DB $database");
    return database;
  }
}