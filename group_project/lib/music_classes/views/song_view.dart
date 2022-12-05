import 'package:flutter/material.dart';
import 'package:group_project/music_classes/models/genre_model.dart';
import '../../MainScreen_Views/custom_circular_progress_indicator.dart';
import '../models/song.dart';

class SongsList extends StatefulWidget {
  const SongsList({Key? key, required this.title }) : super(key: key);
  final String title;

  @override
  State<SongsList> createState() => _SongsListState();
}


class _SongsListState extends State<SongsList> {

  List<Song> allSongs = [];

  final _model = GenreModel();
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
      appBar: AppBar(title: Text(genreSelected),),
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
                      return Container(
                          child: ListTile(
                            title: Text(allSongs[index].name!),
                            subtitle: Text(allSongs[index].duration!),
                            trailing: IconButton(
                              onPressed: () {

                              },
                              icon: Icon(Icons.add),
                            ),
                          )
                      );
                },
                );
              }
            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(Icons.add),
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

  addSong() async {

  }
}
