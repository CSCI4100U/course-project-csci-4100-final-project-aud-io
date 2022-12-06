/*
* Author: Rajiv Williams and Alessandro
* */

import 'package:flutter/material.dart';
import '../music_classes/models/genre.dart';
import '../user_classes/models/genre_model.dart';
import 'dart:math';

class FavoriteGenresView extends StatefulWidget {
  FavoriteGenresView({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  State<FavoriteGenresView> createState() => _FavoriteGenresViewState();
}

class _FavoriteGenresViewState extends State<FavoriteGenresView> {

  GenreModel db = GenreModel();
  List<Color> genreColors = [];
  List allGenres = [];
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
      genreColors.add(
          Color.fromRGBO(
              Random().nextInt(125)+130,
              Random().nextInt(125)+130,
              Random().nextInt(125)+130, 1
          )
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if(isSelected != -1) {
                    deleteGenre(selectedGenre);
                    isSelected = -1;
                  }
                });
              },
              icon: Icon(Icons.delete)
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/home');
            },
            icon: Icon(Icons.home),
          ),
        ],
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: allGenres.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  width: 250,
                  decoration: BoxDecoration(
                    color: genreColors[index],
                    border: Border.all(
                        color: isSelected == index ? Colors.black : genreColors[index],
                        width: 5
                    ),
                    ),
                  child: GestureDetector(
                    child: ListTile(
                      title: Text('${allGenres[index].genre.toString().toUpperCase()}',
                      style: TextStyle(
                          fontSize: 30
                      ), textAlign: TextAlign.center,),
                      tileColor: isSelected == index ? Colors.black : Colors.blue,
                    ),
                    onTap: () {
                      setState(() {
                        print(allGenres[index].id);
                        selectedGenre = allGenres[index].id;
                        if(isSelected == index){
                          isSelected = -1;
                        } else {
                          isSelected = index;
                        }
                        //print(isSelected);
                      });
                    },
                  ),
                ),
              ],
            );
          }
      ),
    );
  }

  // Future _addGenre() async{
  //   FavGenre? newGenre = await Navigator.pushNamed(context, '/heartGenre') as FavGenre?;
  //
  //   if(newGenre != null){
  //     for (int i = 0; i < allGenres.length; i++) {
  //       if (newGenre.genre == allGenres[i].genre) {
  //         final snackBar = SnackBar(
  //             content: Text("you already have ${newGenre.genre} favourited")
  //         );
  //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //         return print("this is not allowed");
  //       }
  //     }
  //     await db.insertGenre(newGenre);
  //     setState(() {
  //       getGenres();
  //     });
  //   }
  // }

  getGenres() async{
    allGenres = await db.getAllGenres();
    setState(() {});
  }

  void deleteGenre(int id) async {
    await db.deleteGenreById(id);
    setState(() {
      allGenres.length - 1;
      getGenres();
    });
  }
}
