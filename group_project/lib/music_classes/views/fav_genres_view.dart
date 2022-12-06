/*
* Author: Rajiv Williams and Alessandro
* */

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:group_project/music_classes/models/fav_genre.dart';
import '../../mainScreen_classes/MainScreen_Model/app_constants.dart';
import '../../user_classes/models/user_model.dart';
import '../models/genre_model.dart';
import 'song_view.dart';

/*
* Class shows current user's favorite genres. They can remove them
* from their favorites and view them from a separate screen, aside
* from the main genres page.
* */
class FavoriteGenresView extends StatefulWidget {
  const FavoriteGenresView({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  State<FavoriteGenresView> createState() => _FavoriteGenresViewState();
}

class _FavoriteGenresViewState extends State<FavoriteGenresView> {

  GenreModel db = GenreModel();
  List<Color> genreColors = [];
  List<FavGenre> allGenres = [];
  int selectedGenre = 0;
  int isSelected = 0;

  @override
  void initState(){
    super.initState();
    getGenres();
  }

  @override
  Widget build(BuildContext context) {
    for(int i = 0; i < allGenres.length; i++){
      genreColors.add(db.genreColors[i]!);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: ListView.builder(
          padding: padding,
          itemCount: allGenres.length,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 9,
                  child: Container(
                    width: 250,
                    color: genreColors[index],
                    child: GestureDetector(
                      child: ListTile(
                        title: Text(allGenres[index].genre.toString().toUpperCase(),
                        style: style, textAlign: TextAlign.center,),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context)=> SongsList(title: allGenres[index].genre!,)));
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                    child: IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: (){
                        _showRemoveGenreAlert(allGenres[index]);
                      },
                    )
                )
              ],
            );
          }
      ),
    );
  }

  /*
  * Shows a Dialog confirming whether the user
  * wants to remove a genre from their favorites.
  * */
  _showRemoveGenreAlert(FavGenre genre){
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(FlutterI18n.translate(context, "dialogs.remove_genre")),
            content: Text(genre.genre.toString().toUpperCase()),
            actions: [
              TextButton(
                  onPressed: (){
                    setState(() {
                      deleteGenre(genre.id!);;
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


  /*
  * Loads all the genres from the local database and
  * updates current user's favorite genres in the
  * cloud database
  * */
  getGenres() async{
    allGenres = await db.getAllGenres();
    UserModel().updateFavGenres(allGenres);
    setState(() {});
  }

  /*
  * Deletes genre from favorites given its
  * id in the local database
  * */
  void deleteGenre(int id) async {
    await db.deleteGenreById(id);
    setState(() {
      allGenres.length - 1;
      getGenres();
    });
  }
}
