import 'package:sqflite/sqflite.dart';
import 'db_utils.dart';
import 'genre.dart';
import 'dart:async';

GenreModel() {
  Future<int> insertGenre(Genre genre) async{
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
    List result = [];
    for (int i = 0; i < maps.length; i++){
      result.add(
          Genre.fromMap(maps[i])
      );
    }
    print(result);
    return result;
  }
}