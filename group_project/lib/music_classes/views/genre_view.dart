/*
* Authors: Mathew Kasbarian, Rajiv Williams and Alessandro Prataviera
* */
import 'package:flutter/material.dart';
import 'package:group_project/mainScreen_classes/MainScreen_Model/app_constants.dart';
import 'package:group_project/music_classes/models/genre_model.dart';
import 'package:group_project/music_classes/views/song_view.dart';
import 'package:group_project/music_classes/models/fav_genre.dart';

import '../../user_classes/models/user_model.dart';

/*
* Class displays the list of all genres available
* in cloud storage and gives the user the ability to
* favorite a genre.
* */
class GenreView extends StatefulWidget {
  const GenreView({Key? key,this.title}) : super(key: key);

  final String? title;

  @override
  State<GenreView> createState() => _GenreViewState();
}

class _GenreViewState extends State<GenreView> {
  final db = GenreModel();
  List allGenres = [];
  late var allFavGenres = [];

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

  /*
  * Displays the list of genres on the cloud storage
  * */
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
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: padding,
                  width: 250,
                  color: db.genreColors[index],
                  child:
                      ListTile(
                        title: TextButton(
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
                        trailing: IconButton(
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
                            icon: isHearted ? Icon(Icons.favorite,color: Colors.black,)
                                : const Icon(Icons.favorite_border,color: Colors.black)
                        ),
                      )
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /*
  * Loads all the hearted genres from the local database and
  * for the hearting genres functionality. Also updates
  * the current user's favorite genres on the cloud storage
  * */
  getFavGenres() async{
    allFavGenres = await db.getAllGenres();
    UserModel().updateFavGenres(allFavGenres);
    setState(() {});
  }

  /*
  * Adds genre to current user's favorite genres
  * */
  Future _addGenre(FavGenre genre) async{
    await db.insertGenre(genre);
    getFavGenres();
  }

  /*
  * Deletes genre from favorites given its
  * id in the local database
  * */
  Future _deleteGenre(int id) async {
    await db.deleteGenreById(id);
    getFavGenres();
  }
}
