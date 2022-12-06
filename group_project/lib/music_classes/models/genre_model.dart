import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../../music_classes/models/db_utils.dart';
import 'fav_genre.dart';

class GenreModel {

  /*
  * Cloud Storage Functions
  * */
  String songCollectionID = "qH6SDHlnOTIVWWuBjnWP";

  List<String> genres = [
    "Hip Hop", "alternative", "classical",
    "dance", "grime", "pop", "rock", "soul"
  ];

  var genreColors = [
    Colors.red[100],
    Colors.blue[100],
    Colors.cyan[100],
    Colors.green[100],
    Colors.yellow[100],
    Colors.orange[100],
    Colors.purple[100],
    Colors.teal[100],
  ];

  /*
  * Local Storage Functions
  * */
  Future<int> insertGenre(FavGenre genre) async{
    final db = await DBUtils.init();
    return db.insert(
      'genre_items',
      genre.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future getAllGenres() async {
    final db = await DBUtils.init();
    final List maps = await db.query('genre_items');
    List<FavGenre> result = [];
    for (int i = 0; i < maps.length; i++){
      result.add(
          FavGenre.fromMap(maps[i])
      );
    }
    print(result);
    return result;
  }

  Future<int> deleteGenreById(int id) async {
    final db = await DBUtils.init();
    return db.delete(
      'genre_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}

