import 'package:flutter/material.dart';
import 'package:group_project/music_classes/models/song_model.dart';

import '../../MainScreen_Model/app_constants.dart';


class PlaylistView extends StatefulWidget {
  const PlaylistView({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  State<PlaylistView> createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  SongModel _model = SongModel();
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
          return Column(
            children: [
              Container(
                padding: padding,
                width: 250,
                color: Colors.red[100+(index*100)],
                child: ListTile(
                  title: Text(mySongs[index].name.toString()),
                  subtitle: Text(mySongs[index].artist.toString()),
                  trailing: Text(mySongs[index].duration.toString()),
                )
              ),
            ],
          );
        },
      ),
    );
  }

  getMySongs() async {
    mySongs = await _model.getAllSongs();
    setState(() {
      print(mySongs);
      mySongs;
    });
  }
}
