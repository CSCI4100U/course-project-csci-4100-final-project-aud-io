
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import '../../mainScreen_classes/MainScreen_Views/custom_circular_progress_indicator.dart';
import '../../user_classes/models/utils.dart';
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
    getAllSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(genreSelected.toUpperCase()),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/playlist");
            },
            icon: const Icon(Icons.view_list_rounded),
          ),
          IconButton(
            onPressed: _addSongToCloudStorage,
            icon: const Icon(Icons.playlist_add),
          )
        ],
      ),
      body: StreamBuilder(
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
                                        name: songOnDisplay.name!,
                                        duration: songOnDisplay.duration!,
                                        artist: songOnDisplay.artist!,
                                        link: songOnDisplay.link
                                    );
                                    _addSongToLocalStorage(song);
                                  },
                                icon: const Icon(Icons.add),
                              )
                          ),
                         ]
                    ),
                  );
                },
              );
            }
          }
      ),
    );
  }
  loadSongs(){
    setState(() {
      getAllSongs();
    });
  }

/*
    gets all songs in database in selected genre
   */
  getAllSongs() async{
    songStream = _songModel.getSongStream(genreSelected);
    allSongs = await _songModel.getSongList(genreSelected);
    setState(() {

    });
  }
/*
adding song to local storage
   */
  _addSongToLocalStorage(Song song) async {
    await _songModel.insertSongLocal(song);
    Utils.showSnackBar("${FlutterI18n.translate(context, "snackbars.added")} ${song.name} ${FlutterI18n.translate(context, "snackbars.to_playlist")}",Colors.black);
  }
/*
adding song to cloud storage
   */
  _addSongToCloudStorage() async{
    var song = await Navigator.of(context).pushNamed('/addSongs') as Song;
    _songModel.insertSong(song,genreSelected);
    getAllSongs();
  }
}