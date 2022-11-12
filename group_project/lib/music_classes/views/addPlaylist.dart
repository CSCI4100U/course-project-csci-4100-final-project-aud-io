/*
* Authors: Mathew Kasbarian
* */

import 'package:flutter/material.dart';
import 'package:group_project/MainScreen_Model/nav.dart';

class AddPlaylistView extends StatefulWidget {
  const AddPlaylistView({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  State<AddPlaylistView> createState() => _AddPlaylistViewState();
}

class _AddPlaylistViewState extends State<AddPlaylistView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarForSubPages(context, widget.title!),
      body: Center(
        child: Column(
          children: [
            Text("Coming Soon...", style: TextStyle(fontSize: 30),),
            Text("This is where you create new playlists.")
          ],
        ),
      )

    );
  }
}