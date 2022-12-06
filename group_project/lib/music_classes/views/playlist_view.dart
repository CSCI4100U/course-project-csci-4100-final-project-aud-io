import 'package:flutter/material.dart';
import 'package:group_project/music_classes/models/song_model.dart';

import '../../MainScreen_Model/app_constants.dart';
import '../../user_classes/models/utils.dart';
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
        padding: padding,
        itemCount: mySongs.length,
        itemBuilder: (context, index){
          Song songOnDisplay = mySongs[index];
          return Row(
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
            title: const Text("Remove from Playlist?"),
            content: Text("${song.name}"),
            actions: [
              TextButton(
                  onPressed: (){
                    setState(() {
                      _removeSongFromPlaylist(song.id!);;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Remove")
              ),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")
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
