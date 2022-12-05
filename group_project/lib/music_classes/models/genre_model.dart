import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_project/music_classes/models/song.dart';
import 'dart:async';
import 'genreCreator.dart';
import 'package:sqflite/sqflite.dart';
import '../../music_classes/models/db_utils.dart';
import 'genre.dart';

class GenreModel {

  /*
  * Cloud Storage Functions
  * */
  String songCollectionID = "qH6SDHlnOTIVWWuBjnWP";

  List<String> genres = [
    "Hip Hop", "alternative", "classical",
    "dance", "grime", "pop", "rock", "soul"
  ];

  Stream getSongStream(String genre) async* {
    print("retrieving genres");
    yield await FirebaseFirestore.instance.collection('songs')
        .doc(songCollectionID)
        .collection(genre).get();
  }


  Future<List<Song>> getSongList(String genre) async {
    QuerySnapshot songs = await FirebaseFirestore.instance.collection('songs')
        .doc(songCollectionID)
        .collection(genre).get();

    List<Song> allSongs = songs.docs.map<Song>((user) {
      final songs = Song.fromMap(
          user.data(),
          reference: user.reference);
      return songs;
    }).toList();

    return allSongs;
  }

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
    List result = [];
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

