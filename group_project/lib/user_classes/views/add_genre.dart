/*
* Author: Alessandro Prataviera
* */

import 'package:flutter/material.dart';
import '../../music_classes/models/genre.dart';

class AddGenre extends StatefulWidget {
  const AddGenre({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  State<AddGenre> createState() => _AddGenreState();
}

class _AddGenreState extends State<AddGenre> {
  var favGenre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Row(
                children: [
                  Text('Favourite Genre:', style: TextStyle(fontSize: 30)),
                  Flexible(
                      child: TextField(
                        onChanged: (value) {
                          favGenre = value;
                        },
                      )
                  )
                ],
              )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if (favGenre != null){
            Genre genre = Genre();
            genre = Genre(genre: favGenre);
            print(favGenre);
            Navigator.of(context).pop(genre);
          }
          else {
            print('insert a sid and grade');
          }
        },
        // Navigator.pop(context)
        child: const Icon(Icons.save),
      ),
    );
  }
}
