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


  @override
  void initState(){
    super.initState();
    loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarForSubPages(context, widget.title!),
      body: Column(
        children: [
          TextFormField(
              style: style,
              decoration: InputDecoration(
                  label: Text("song name"),
                  hintText: "Despacito"
              ),
              onChanged: (value){
                setState(() {
                  songNameEntered = value;
                });
              }
          ),
          TextFormField(
              style: style,
              decoration: InputDecoration(
                  label: Text("song artist"),

                  hintText: "Luis Fonsi"
              ),
              onChanged: (value){
                setState(() {
                  songArtistEntered = value;
                });
              }
          ),
          TextFormField(
              style: style,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  label: Text("song artist"),
                  hintText: "4:15"
              ),
              validator: (value) {
                if (value == null || value[1].contains(':')) {
                  return songDurationEntered;
                } else {
                  songDurationEntered = value;
                  return null;
                }
              }
          ),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
              ),
              onPressed:() {
                var song=Song(
                  name: songNameEntered,
                  artist: songArtistEntered,
                  duration: songDurationEntered
                );
                Navigator.of(context).pop(song);
              },
              icon: const Icon(Icons.arrow_forward, size: 20),
              label: Text(
                FlutterI18n.translate(context, "titles.signup"),
                style: style,
              )
          ),
          const SizedBox(height: 14,),
        ],

      ),
    );
  }

  // Updates widget with current users in cloud storage
  loadUsers(){
    setState(() {

    });
  }
  Future AddSong() async{


}

}
