import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:group_project/music_classes/models/genre_model.dart';
import '../../MainScreen_Views/custom_circular_progress_indicator.dart';
import '../../user_classes/models/profile.dart';
import '../models/song.dart';

class SongsList extends StatefulWidget {
  const SongsList({Key? key, this.title }) : super(key: key);
  final String? title;

  @override
  State<SongsList> createState() => _SongsListState();
}


class _SongsListState extends State<SongsList> {

  List<Song> allSongs = [];
  TextStyle style = const TextStyle(fontSize: 30);

  final _model = GenreModel();
  late Stream SongListStream;

  @override
  void initState(){
    super.initState();
    SongListStream = _model.getGenre(widget.title!);
    loadSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title!),),
      body: Container(
        child:
        StreamBuilder(
            stream: SongListStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              print("Snapshot: $snapshot");
              if(!snapshot.hasData){
                print("Data is missing from SongList");
                return const CustomCircularProgressIndicator();
              }
              else{
                print("Found data for SongList");
                print(allSongs);
                return ListView.builder(
                    itemCount: allSongs.length,
                  itemBuilder: (context, index) {
                      return Container(
                          child: Text("${allSongs[index].name}")

                      );
                },
                );
              }

            }

        ),
      ),

    );
  }
  loadSongs(){
    setState(() {
      getAllSongs();
    });
  }

  /*
  * Function reloads friend stream and updates the
  * List of all the friends of the current user
  * */
  getAllSongs() async{
    SongListStream = _model.getGenre(widget.title!);
    allSongs = await _model.getSongList(widget.title!);
  }
}
