/*
* Authors: Mathew Kasbarian, Rajiv Williams
* */

import 'package:flutter/material.dart';
import 'package:group_project/MainScreen_Model/nav.dart';
import 'package:group_project/music_classes/models/song_model.dart';
import '../models/playlist.dart';
import '../models/song.dart';

class PlayListView extends StatefulWidget {
  const PlayListView({Key? key,this.title}) : super(key: key);

  final String? title;

  @override
  State<PlayListView> createState() => _PlayListViewState();
}

class _PlayListViewState extends State<PlayListView> {
  final _model = SongModel();
  List<Playlist> allPlaylists = [
    Playlist(title:"Playlist 1",
        creatorUserName: "rajiv45",
        allSongs: [
          Song(name: "Stronger", artist:"Kanye",
            duration: "2:42"),
          Song(name: "Praise God", artist:"Kanye",
              duration: "2:42"),
          Song(name: "Conception", artist:"Black Thought",
              duration: "2:42"),
        ]
    ),
    Playlist(title:"Playlist 2",
        creatorUserName: "rajiv45",
        allSongs: [
          Song(name: "Rich Flex", artist:"Drake",
              duration: "2:42"),
          Song(name: "Follow God", artist:"Kanye",
              duration: "2:42"),
          Song(name: "Circo Loco", artist:"Drake",
              duration: "2:42"),
        ]
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarForSubPages(context, widget.title!),
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: allPlaylists.length,
        itemBuilder: (context, index){
          Playlist playlist = allPlaylists[index];
          int playlistLength = playlist.allSongs!.length;
          return
            Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
                children:[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(237, 195, 243, 1.0)
                    ),
                    child: ListTile(
                      title: Text(playlist.title!,
                        style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Creator: ${playlist.creatorUserName!}"),
                    ),
                  ),
                  Container(
                    height: 100.0 * playlistLength,
                      child: ListView(
                          children: playlist.allSongs!.map<Widget>((song) =>
                              buildSong(song)).toList()
                      ),
                  )
                ]
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          Navigator.pushNamed(context, '/addPlaylist');
        } ,
        tooltip: "Add",
        child: const Icon(Icons.playlist_add),
      ),
    );
  }

  buildSong(Song song){
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(227, 227, 227, 1.0)
      ),
      child: ListTile(
        title: Text(song.name!),
        subtitle: Text(song.artist!),
        trailing: Text(song.duration!),
      ),
    );
  }
}
