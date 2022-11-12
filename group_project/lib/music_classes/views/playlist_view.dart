/*
* Authors: Mathew Kasbarian, Rajiv Williams
* */

import 'package:flutter/material.dart';
import 'package:group_project/MainScreen_Model/nav.dart';
import '../models/playlist.dart';
import '../models/song.dart';

class PlayListView extends StatefulWidget {
  const PlayListView({Key? key,this.title}) : super(key: key);

  final String? title;

  @override
  State<PlayListView> createState() => _PlayListViewState();
}

class _PlayListViewState extends State<PlayListView> {

  List<Playlist> allPlaylists = [
    Playlist(title:"Playlist 1",
        creatorUserName: "rajiv45",
        allSongs: [
          Song(title: "Stronger", artistName:"Kanye",
            duration: "2:42",album: "Graduation",genre: "Rap"),
          Song(title: "Praise God", artistName:"Kanye",
              duration: "2:42",album: "Donda",genre: "Rap"),
          Song(title: "Conception", artistName:"Black Thought",
              duration: "2:42",album: "Conception",genre: "Rap"),
        ]
    ),
    Playlist(title:"Playlist 2",
        creatorUserName: "rajiv45",
        allSongs: [
          Song(title: "Rich Flex", artistName:"Drake",
              duration: "2:42",album: "Her Loss",genre: "Rap"),
          Song(title: "Follow God", artistName:"Kanye",
              duration: "2:42",album: "Jesus is King",genre: "Rap"),
          Song(title: "Circo Loco", artistName:"Drake",
              duration: "2:42",album: "Her Loss",genre: "Rap"),
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
        title: Text(song.title!),
        subtitle: Text(song.artistName!),
        trailing: Text(song.duration!),
      ),
    );
  }
}
