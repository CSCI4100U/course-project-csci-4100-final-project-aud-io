import 'artist.dart';
class Song {
  String? title;
  int? length;
  Artist? artist;
  String? album;
  String? name;
  String? genre;
  Song({this.title, this.length, this.album,required this.name,required this.genre});

  @override
  String toString() {
    return " title: $title name: $name length: $length album: $album genre: $genre ";
  }
}
