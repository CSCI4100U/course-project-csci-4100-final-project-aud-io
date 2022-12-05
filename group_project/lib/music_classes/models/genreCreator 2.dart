
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_project/music_classes/models/song.dart';
import '../../user_classes/models/profile.dart';
import '';
class Genre{
  String? title;
  DocumentReference? reference;
  List<Song>? allSongs;

  Genre({this.title,this.allSongs});
  Genre.fromMap(var map, {this.reference}){
    this.title = map['title'];
    this.allSongs = map['allSongs'];

  }

  Map<String,Object?> toMap(){
    return {
      'title': this.title,
      'allSongs': this.allSongs,

    };
  }
  @override
  String toString(){
    return 'genre: $title, songs: $allSongs';
  }

}