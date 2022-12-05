/*
* Authors: Mathew Kasbarian, Rajiv Williams
* */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_project/MainScreen_Model/app_constants.dart';
import 'package:group_project/MainScreen_Model/navigation_bar.dart';
import 'package:group_project/music_classes/models/genre_model.dart';
import 'package:group_project/music_classes/models/song_model.dart';
import 'package:group_project/music_classes/views/song_view.dart';
import '../models/genreCreator.dart';
import '../models/song.dart';

class genreView extends StatefulWidget {
  const genreView({Key? key,this.title}) : super(key: key);

  final String? title;

  @override
  State<genreView> createState() => _genreViewState();
}

class _genreViewState extends State<genreView> {
  final _model = GenreModel();
  List allgenres = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allgenres= _model.genres;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarForSubPages(context, widget.title!),
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: allgenres.length,
        itemBuilder: (context, index){
          String genre = allgenres[index];
          return Container(
            height: 50,
            color: Colors.red[100+(index*100)],
            child: TextButton(
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
          );
        },
      ),

    );
  }

}
