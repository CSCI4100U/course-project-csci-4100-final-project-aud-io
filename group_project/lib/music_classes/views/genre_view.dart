/*
* Authors: Mathew Kasbarian, Rajiv Williams and Alessandro Prataviera
* */
import 'package:flutter/material.dart';
import 'package:group_project/MainScreen_Model/app_constants.dart';
import 'package:group_project/MainScreen_Model/navigation_bar.dart';
import 'package:group_project/music_classes/models/genre_model.dart';
import 'package:group_project/music_classes/views/song_view.dart';
import 'package:group_project/music_classes/models/fav_genre.dart';

class GenreView extends StatefulWidget {
  const GenreView({Key? key,this.title, required this.heartBool}) : super(key: key);

  final String? title;
  final bool heartBool;

  @override
  State<GenreView> createState() => _GenreViewState();
}

class _GenreViewState extends State<GenreView> {
  final db = GenreModel();
  List allGenres = [];
  late var allFavGenres = [];
  var colors = [
    Colors.red[100],
    Colors.blue[100],
    Colors.cyan[100],
    Colors.green[100],
    Colors.yellow[100],
    Colors.orange[100],
    Colors.purple[100],
    Colors.teal[100],
  ];

  @override
  void initState() {
    super.initState();
    allGenres = db.genres;
    getFavGenres();
  }

  @override
  Widget build(BuildContext context) {
    return genreList();
  }

  Widget genreList() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).pushNamed('/favGenres');
              },
              icon: Icon(Icons.favorite_border)
          )
        ],
      ),
      body: ListView.builder(
        padding: padding,
        itemCount: allGenres.length,
        itemBuilder: (context, index){
          String genreOnDisplay = allGenres[index];
          bool isHearted = false;
          FavGenre? favGenreToBeDeleted;
          for (int i = 0; i < allFavGenres.length; i++) {
            if (genreOnDisplay == allFavGenres[i].genre) {
              favGenreToBeDeleted = FavGenre(genre: genreOnDisplay,id: allFavGenres[i].id);
              isHearted = true;
            }
          }
          return Column(
            children: [
              Container(
                padding: padding,
                width: 250,
                color: colors[index],
                child: Row(
                  children: [
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context)=> SongsList(title: genreOnDisplay,)));
                      },
                      child: Text("${genreOnDisplay.toUpperCase()}",
                        style: const TextStyle(fontSize: fontSize,
                          color: Colors.black,

                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (!isHearted) {
                              // add to database
                              FavGenre favGenre = FavGenre();
                              favGenre = FavGenre(genre: genreOnDisplay);
                              _addGenre(favGenre);
                            }
                            else{
                              //remove from database
                              if(favGenreToBeDeleted != null){
                                _deleteGenre(favGenreToBeDeleted.id!);
                              }
                            }
                          });
                        },
                        icon: isHearted ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_border)
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  getFavGenres() async{
    allFavGenres = await db.getAllGenres();
    setState(() {

    });
  }

  Future _addGenre(FavGenre genre) async{
    await db.insertGenre(genre);
    getFavGenres();
  }

  Future _deleteGenre(int id) async {
    await db.deleteGenreById(id);
    getFavGenres();
  }
}
