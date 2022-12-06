/*
* Author: Rajiv Williams
* */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/MainScreen_Views/custom_circular_progress_indicator.dart';
import '../../MainScreen_Model/navigation_bar.dart';
import 'package:group_project/music_classes/models/song.dart';
import 'package:group_project/music_classes/models/song_model.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:group_project/MainScreen_Model/app_constants.dart';
import 'package:group_project/music_classes/models/song_model.dart';
import '../../user_classes/models/user_model.dart';

class AddSongs extends StatefulWidget {
  AddSongs({Key? key, this.title}) : super(key: key);

  String? title;



  @override
  State<AddSongs> createState() => _AddSongsState();
}

class _AddSongsState extends State<AddSongs> {
  var formKey = GlobalKey<FormState>();
  String songNameEntered = "";
  String songArtistEntered = "";
  String songDurationEntered = "";
  var songModel=SongModel();
  var genreEntered= "";
  @override
  void initState(){
    super.initState();
    loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBarForSubPages(context, widget.title!),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: formKey,
          child: Column(
              children: [
              TextFormField(
              style: style,
              decoration: InputDecoration(
                  label: Text("Song Name"),
                  hintText: "Despacito"
              ),
              validator: (value){
                if (value == null || !value.contains(':')) {
                  return  "Invalid Song Name";
                } else {
                  songNameEntered = value;
                  return null;
                }
              }
          ),
            TextFormField(
                style: style,
                decoration: InputDecoration(
                    label: Text("Song Artist"),

                    hintText: "Luis Fonsi"
                ),
                validator: (value) {
                  if (value == null || !value.contains(':')) {
                    return "Invalid Artist Name";
                  } else {
                    songArtistEntered = value;
                    return null;
                  }
                }
            ),

            TextFormField(
                style: style,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    label: Text("Song Duration"),
                    hintText: "4:15"
                ),
                validator: (value) {
                  if (value == null || !value.contains(':')) {
                      return "Invalid Duration";
                  } else {
                    songDurationEntered = value;
                    return null;
                  }
                }
            ),
            DropdownButtonFormField(
                style: const TextStyle(fontSize: fontSize, color: Colors.black),
                decoration: InputDecoration(
                    labelText: "genre",
                    icon: const Icon(Icons.music_note)),
                validator:(value){
                  if(value == null){
                    return "Pick Genre";
                  }
                  else {
                    genreEntered=value;
                    return null;
                  }
                },
                items: songModel.genres
                .map<DropdownMenuItem>((String value){
                return DropdownMenuItem(
                value: value,
                child: Text(value),

                );
                }).toList(),
                isExpanded: true,
                onChanged: (value) {
                print("genre: $value");
                genreEntered = value.toString();
        },

      ), ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(50),
          ),
          onPressed:() {
            final isValid= formKey.currentState!.validate();
            if (!isValid){
              return;
            }
            var song=Song(
                name: songNameEntered,
                artist: songArtistEntered,
                duration: songDurationEntered
            );
            songModel.insertSong(song,genreEntered);
            Navigator.of(context).pop(song);
          },
          icon: const Icon(Icons.arrow_forward, size: 20),
          label: Text(
            FlutterI18n.translate(context, "Add Song"),
            style: style,
          )
      ),
          const SizedBox(height: 14,),
      ],
    ),

        ),
      ),
    );
  }
  loadUsers(){
    setState(() {
    });
  }
}
