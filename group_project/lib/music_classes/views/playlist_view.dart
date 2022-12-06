import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:group_project/music_classes/models/song_model.dart';
import '../models/song.dart';


class PlaylistView extends StatefulWidget {
  const PlaylistView({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  State<PlaylistView> createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  final SongModel db = SongModel();
  List mySongs = [];
  @override
  void initState() {
    super.initState();
    getMySongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: ListView.builder(
        itemCount: mySongs.length,
        itemBuilder: (context, index){
          Song songOnDisplay = mySongs[index];
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 1
                  )
                ]
            ),
            child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: ListTile(
                        title: Text(songOnDisplay.name!),
                        subtitle: Text(songOnDisplay.artist!),
                        trailing: Text(songOnDisplay.duration!)
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () {
                          Song song = Song();
                          song = Song(
                              id: songOnDisplay.id,
                              name: songOnDisplay.name!,
                              duration: songOnDisplay.duration!,
                              artist: songOnDisplay.artist!,
                              link: songOnDisplay.link
                          );
                          _showRemoveSongAlert(song);
                        },
                        icon: const Icon(Icons.delete),
                      )
                  ),
                ]
            ),
          );
        },
      ),
    );
  }

  getMySongs() async {
    mySongs = await db.getAllSongs();
    setState(() {
      print(mySongs);
      mySongs;
    });
  }
  _showRemoveSongAlert(Song song){
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(FlutterI18n.translate(context, "dialogs.remove_playlist")),
            content: Text("${song.name}"),
            actions: [
              TextButton(
                  onPressed: (){
                    setState(() {
                      _removeSongFromPlaylist(song.id!);;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(FlutterI18n.translate(context, "dialogs.remove"))
              ),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text(FlutterI18n.translate(context, "dialogs.cancel"))
              )
            ],
          );
        }
    );
  }
  
  Future _removeSongFromPlaylist(int id) async {
    await db.deleteSongByID(id);
    getMySongs();
  }
}
