import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_project/music_classes/models/song.dart';
import 'dart:async';
import 'genreCreator.dart';

class GenreModel {

  String songCollectionID = "qH6SDHlnOTIVWWuBjnWP";

  List<String> genres = [
    "Hip Hop", "alternative", "classical",
    "dance", "grime", "pop", "rock", "soul"
  ];

  Stream getGenre(String genre) async* {
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

  }

