
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

  final _model = GenreModel();
  final _songModel = SongModel();
  late Stream songStream;
  late String genreSelected = widget.title;

  @override
  void initState(){
    super.initState();
    songStream = _model.getSongStream(genreSelected);
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
            icon: Icon(Icons.playlist_add),
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
                      return Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: ListTile(
                                title: Text(allSongs[index].name!),
                                subtitle: Text(allSongs[index].artist!),
                                trailing: Text(allSongs[index].duration!)
                              ),
                            ),

                            Expanded(
                              flex: 1,
                                child: IconButton(
                                  onPressed: () {
                                      Song song = Song();
                                      song = Song(
                                        name: allSongs[index].name!,
                                        duration: allSongs[index].duration!,
                                        artist: allSongs[index].artist!,
                                        link: allSongs[index].link
                                      );
                                      addSong(song);
                                      Navigator.of(context).pushNamed("/playlist");
                                    },
                                  icon: Icon(Icons.add),
                                )
                            )
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
    songStream = _model.getSongStream(genreSelected);
    allSongs = await _model.getSongList(genreSelected);
  }

  addSong(Song song) async {
    await _songModel.insertSongLocal(song);
  }

  addSongToCloudStorage() async{
    var song = await Navigator.of(context).pushNamed('/addSongs');
    
  }
}