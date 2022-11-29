/*
* Author: Rajiv Williams
* */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'song.dart';

class SongModel{

  List<String> genres = [
    "Hip Hop", "alternative", "classical",
    "dance", "grime", "pop", "rock", "soul"
  ];

  String songCollectionID = "qH6SDHlnOTIVWWuBjnWP";
  /*
  * Insert newly signed up user into database
  * */
  Future insertSong(Song song, String genre) async{

    song.genre = genre;

    print("Adding new song...");
    // Add song to 'songs->genre' collection
    FirebaseFirestore.instance.collection('songs')
        .doc(songCollectionID)
        .collection(genre).doc().set(song.toMap());

    print("Added: $song to '$genre' collection");

  }
}