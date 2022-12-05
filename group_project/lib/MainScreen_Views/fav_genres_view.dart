/*
* Author: Rajiv Williams
* */

import 'package:flutter/material.dart';
import 'package:group_project/MainScreen_Model/navigation_bar.dart';

import '../music_classes/models/genre.dart';
import '../user_classes/models/genre_model.dart';
import 'dart:math';

class FavoriteGenresView extends StatefulWidget {
  const FavoriteGenresView({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  State<FavoriteGenresView> createState() => _FavoriteGenresViewState();
}

class _FavoriteGenresViewState extends State<FavoriteGenresView> {

  var allGenres = [];
  GenreModel db = GenreModel();
  List<Color> genreColors = [];

  @override
  void initState(){
    super.initState();
    getGenres();
  }

  @override
  Widget build(BuildContext context) {
    for(int i = 0; i < allGenres.length; i++){
      genreColors.add(
          Color.fromRGBO(
              Random().nextInt(125)+130,
              Random().nextInt(125)+130,
              Random().nextInt(125)+130, 1
          )
      );
    }
    return Scaffold(
      appBar: buildAppBarForSubPages(context, widget.title!),
      body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: allGenres.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  width: 250,
                  color: genreColors[index],
                  child: GestureDetector(
                    child: ListTile(
                      title: Text('${allGenres[index].genre.toString().toUpperCase()}',
                      style: TextStyle(
                          fontSize: 30
                      ), textAlign: TextAlign.center,),
                    ),
                    onTap: () {

                    },
                  ),
                ),
              ],
            );
          }
      ),
      //TODO: Change this functionality to hearts beside genres in GenresView
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addGenre,
      ),
    );
  }

  Future _addGenre() async{
    Genre newGenre = await Navigator.pushNamed(context, '/addGenre') as Genre;

    print(newGenre);
    await db.insertGenre(newGenre);
    setState(() {
      getGenres();
    });
  }

  getGenres() async{
    allGenres = await db.getAllGenres();
    setState(() {});
  }
}
