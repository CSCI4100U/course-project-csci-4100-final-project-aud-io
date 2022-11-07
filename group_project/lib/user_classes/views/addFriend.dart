import 'package:flutter/material.dart';
import '../models/profile.dart';

class AddFriendSearch extends StatefulWidget {
  const AddFriendSearch({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<AddFriendSearch> createState() => _AddFriendSearchState();
}

class _AddFriendSearchState extends State<AddFriendSearch> {
  var formKey = GlobalKey<FormState>();

  String? userID;
  String? userName;
  String? phoneNum;
  String? country;
  String? city;

  TextStyle style = TextStyle(fontSize: 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Text("TODO: Add Search Bar to search for friends."),
      //Todo: Have add Button as trailing in List of List Tiles
      // if friend already added, don't include in search results, etc.
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Profile newFriend = Profile(
              userID: userID,
              userName: userName,
              phoneNum: phoneNum,
              country: country,
              city: city
          );
          Navigator.of(context).pop(newFriend);
        },
        tooltip: 'Save',
        child: const Icon(Icons.person_add),
      ),
    );
  }
}