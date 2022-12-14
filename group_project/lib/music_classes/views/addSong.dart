/*
* Author: Rajiv Williams
* */

import 'package:flutter/material.dart';
import '../../mainScreen_classes/MainScreen_Model/navigation_bar.dart';
import 'package:group_project/music_classes/models/song.dart';
import 'package:group_project/music_classes/models/song_model.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:group_project/mainScreen_classes/MainScreen_Model/app_constants.dart';

class AddSongs extends StatefulWidget {
  const AddSongs({Key? key, this.title, this.genreSelected}) : super(key: key);

  final String? title;
  final String? genreSelected;



  @override
  State<AddSongs> createState() => _AddSongsState();
}

class _AddSongsState extends State<AddSongs> {
  var formKey = GlobalKey<FormState>();
  String songNameEntered = "";
  String songArtistEntered = "";
  String songDurationEntered = "";
  var songModel=SongModel();
  late var genreEntered= widget.genreSelected;
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
                const SizedBox(height: 14,),
                TextFormField(
              style: style,
              decoration: InputDecoration(
                  label: Text(FlutterI18n.translate(context, "forms.song_name")),
                  hintText: "Despacito"
              ),
              validator: (value){
                if (value == '' || value == null) {
                  return FlutterI18n.translate(context, "forms.errors.valid_song_name");
                } else {
                  songNameEntered = value!;
                  return null;
                }
              }
          ),
                const SizedBox(height: 14,),
                TextFormField(
                style: style,
                decoration: InputDecoration(
                    label: Text(FlutterI18n.translate(context, "forms.song_artist")),

                    hintText: "Luis Fonsi"
                ),
                validator: (value) {
                  if (value == '' || value == null) {
                    return FlutterI18n.translate(context, "forms.errors.valid_song_artist");
                  } else {
                    songArtistEntered = value;
                    return null;
                  }
                }
            ),
                const SizedBox(height: 14,),
                TextFormField(
                  style: style,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      label: Text(FlutterI18n.translate(context, "forms.song_duration")),
                      hintText: "4:15"
                  ),
                  validator: (value) {
                    if (value == null || !value.contains(':')) {
                      return FlutterI18n.translate(context, "forms.errors.valid_duration");
                    } else {
                      songDurationEntered = value;
                      return null;
                    }
                  }
                  ),
                const SizedBox(height: 14,),
                DropdownButtonFormField(
                style: const TextStyle(fontSize: fontSize, color: Colors.black),
                decoration: InputDecoration(
                    labelText: FlutterI18n.translate(context, "titles.genre"),
                    icon: const Icon(Icons.music_note)),
                validator:(value){
                  if(value == null){
                    return FlutterI18n.translate(context, "forms.errors.valid_genre");
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
                ),
                const SizedBox(height: 14,),
                ElevatedButton.icon(
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
                      duration: songDurationEntered,
                  );
                  Navigator.of(context).pop([song,genreEntered]);
                },
                    icon: const Icon(Icons.arrow_forward, size: 20),
                    label: Text(
                      FlutterI18n.translate(context, "titles.add_song"),
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
