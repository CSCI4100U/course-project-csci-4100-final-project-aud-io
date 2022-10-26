import 'package:flutter/material.dart';

class FriendList extends StatefulWidget {
  const FriendList({Key? key,this.title}) : super(key: key);

  final String? title;

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        actions: [
          IconButton(
              onPressed: (){
                //call _deleteFriend()
              },
              tooltip: 'Delete Friend',
              icon: const Icon(Icons.delete)
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            child: Text("Friend 1"),
          ),
          Container(
            child: Text("Friend 2"),
          ),
          Container(
            child: Text("Friend 3"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //call _addFriend()
        },
        tooltip: 'Add Friend',
        child: const Icon(Icons.add),
      ),
    );
  }
}
