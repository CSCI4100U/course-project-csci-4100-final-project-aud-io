import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  int? id;
  String? name;
  String? duration;
  String? artist;
  String? link;
  String? _genre;
  DocumentReference? reference;
  Song({this.id,this.name, this.duration, this.artist, this.link});

  Song.fromMap(var map, {this.reference}){
    this.id = map['id'];
    this.name = map['name'];
    this.duration = map['duration'];
    this.artist = map['artist'];
    this.link = map['link'];
  }

  Map<String,Object?> toMap(){
    return {
      'id': this.id,
      'name': this.name,
      'duration': this.duration,
      'artist': this.artist,
      'link': this.link,
    };
  }

  String? get genre => _genre;

  set genre(genre){
    _genre = genre;
  }

  @override
  String toString() {
    return "{$id} '$name' by $artist - ($duration) - Genre: $genre ";
  }
}
