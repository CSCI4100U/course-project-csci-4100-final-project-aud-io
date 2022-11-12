import 'package:group_project/music_classes/models/song.dart';
import '../../user_classes/models/profile.dart';

class Playlist{
  String? title;
  String? creatorUserName;
  List<Song>? allSongs;

  Playlist({this.title,this.creatorUserName,this.allSongs});

  @override
  String toString(){
    return 'Playlist: $title, Creator: $creatorUserName, songs: $allSongs';
  }

}