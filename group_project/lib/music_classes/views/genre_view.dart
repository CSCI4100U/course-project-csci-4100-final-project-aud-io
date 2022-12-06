/*
* Authors: Mathew Kasbarian, Rajiv Williams and Alessandro Prataviera
* */
import 'package:flutter/material.dart';
import 'package:group_project/MainScreen_Model/app_constants.dart';
import 'package:group_project/MainScreen_Model/navigation_bar.dart';
import 'package:group_project/music_classes/models/genre_model.dart';
import 'package:group_project/music_classes/views/song_view.dart';
import 'package:group_project/music_classes/models/genre.dart';

class genreView extends StatefulWidget {
  const genreView({Key? key,this.title, required this.heartBool}) : super(key: key);

  final String? title;
  final bool heartBool;

  @override
  State<genreView> createState() => _genreViewState();
}

class _genreViewState extends State<genreView> {
  final _model = GenreModel();

  List allGenres = [];
  List clicked = [false,false,false,false,false,false,false,false];
  List<FavGenre> tempGenres = [];
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
    allGenres = _model.genres;
  }

  @override
  Widget build(BuildContext context) {
    return widget.heartBool? genreHeartList(): genreList();
  }

  Widget genreList() {
    return Scaffold(
      appBar: buildAppBarForSubPages(context, widget.title!),
      body: ListView.builder(
        padding: padding,
        itemCount: allGenres.length,
        itemBuilder: (context, index){

          String genre = allGenres[index];
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
                                builder: (context)=> SongsList(title: genre,)));
                      },
                      child: Text("${genre.toUpperCase()}",
                        style: const TextStyle(fontSize: fontSize,
                          color: Colors.black,
                        ),
                      ),
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

  Widget genreHeartList() {
    return Scaffold(
      appBar: buildAppBarForSubPages(context, widget.title!),
      body: ListView.builder(
        padding: padding,
        itemCount: allGenres.length,
        itemBuilder: (context, index){
          String genre = allGenres[index];
          return Column(
            children: [
              Container(
                padding: padding,
                width: 250,
                color: Colors.red[100+(index*100)],
                child: Row(
                  children: [
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context)=> SongsList(title: genre,)));
                      },
                      child: Text("${genre.toUpperCase()}",
                        style: const TextStyle(fontSize: fontSize,
                          color: Colors.black,

                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (clicked[index] == false) {
                              clicked[index] = true;
                              FavGenre genre = FavGenre();
                              genre = FavGenre(genre: allGenres[index]);
                              print(allGenres[index]);
                              Navigator.of(context).pop(genre);
                            }
                            else {
                              clicked[index] = false;
                              Navigator.of(context).pop(allGenres[index]);
                            }
                            print(clicked[index]);
                          });
                        },
                        icon: clicked[index]? Icon(Icons.favorite) : Icon(Icons.favorite_border)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
