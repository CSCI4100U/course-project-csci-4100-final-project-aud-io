import 'artist.dart';
class Song {
  String? title;
  String? duration;
  String? artistName;
  String? album;
  String? genre;
  Song({this.title, this.duration, this.artistName,this.album,this.genre});

  @override
  String toString() {
    return " title: $title artist: $artistName duration: $duration album: $album genre: $genre ";
  }
}
