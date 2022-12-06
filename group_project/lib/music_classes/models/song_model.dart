/*
* Author: Rajiv Williams
* */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'db_utils.dart';
import 'song.dart';

class SongModel{

  List<String> genres = [
    "Hip Hop", "alternative", "classical",
    "dance", "grime", "pop", "rock", "soul"
  ];

  String songCollectionID = "qH6SDHlnOTIVWWuBjnWP";

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


  Future insertSong(Song song, String genre) async{

    song.genre = genre;

    print("Adding new song...");
    // Add song to 'songs->genre' collection
    FirebaseFirestore.instance.collection('songs')
        .doc(songCollectionID)
        .collection(genre).doc().set(song.toMap());

    print("Added: $song to '$genre' collection");

  }

  Future getAllSongs() async {
    final db = await SongDBUtils.init();
    final List maps = await db.query('playlist_songs');
    List result = [];
    for (int i = 0; i < maps.length; i++){
      result.add(
          Song.fromMap(maps[i])
      );
    }
    print(result);
    return result;
  }

  Future<int> insertSongLocal(Song song) async{
    final db = await SongDBUtils.init();
    return db.insert(
      'playlist_songs',
      song.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteSongByID(int id) async {
    final db = await SongDBUtils.init();
    return db.delete(
      'playlist_songs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}