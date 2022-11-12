import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class PlayListView extends StatefulWidget {
  const PlayListView({Key? key,this.title}) : super(key: key);

  final String? title;

  @override
  State<PlayListView> createState() => _PlayListViewState();
}

class _PlayListViewState extends State<PlayListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title!),
        actions: [
          IconButton(
            onPressed: (){
              //Call async function that goes to route "/notifications"
              //Navigator.pushNamed(context, '/notifications');
            },
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: (){
              //Call async function that goes to route "/settings"
            },
            icon: Icon(Icons.settings_outlined),
          ),
        ],
      ),

      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 5,
        itemBuilder: (context, index){
          return (
              Column(
                  children:[
                    Text("Song $index"),
                  ]
              )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){} ,
        tooltip: "Add",
        child: const Icon(Icons.add),
      ),
    );
  }
}
