
import 'package:flutter/material.dart';
import 'package:group_project/music_classes/models/genre_model.dart';
import '../../MainScreen_Views/custom_circular_progress_indicator.dart';
import '../models/song.dart';
import '../models/song_model.dart';

class SongsList extends StatefulWidget {
  const SongsList({Key? key, required this.title }) : super(key: key);
  final String title;

  @override
  State<SongsList> createState() => _SongsListState();
}


class _SongsListState extends State<SongsList> {

  List<Song> allSongs = [];
  List<bool> isAdded = [];
  final _songModel = SongModel();
  late Stream songStream;
  late String genreSelected = widget.title;

  @override
  void initState(){
    super.initState();
    songStream = _songModel.getSongStream(genreSelected);
    loadSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(genreSelected),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/addSongs");
            },
            icon: const Icon(Icons.view_list_rounded),
          )
        ],
      ),
      body: Container(
        child:
        StreamBuilder(
            stream: songStream,
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
                    Song songOnDisplay = allSongs[index];
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
                                        name: songOnDisplay.name!,
                                        duration: songOnDisplay.duration!,
                                        artist: songOnDisplay.artist!,
                                        link: songOnDisplay.link
                                    );
                                    addSong(song);
                                  },
                                icon: const Icon(Icons.add),
                              )
                          ),
                         ]
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
    songStream = _songModel.getSongStream(genreSelected);
    allSongs = await _songModel.getSongList(genreSelected);
  }

  addSong(Song song) async {
    await _songModel.insertSongLocal(song);
  }

  addSongToCloudStorage() async{
    var song = await Navigator.of(context).pushNamed('/addSongs');
    
  }
}