import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../models/userModel.dart';

class FriendList extends StatefulWidget {
  const FriendList({Key? key,this.title}) : super(key: key);

  final String? title;

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  //Todo: Get allFriends from local storage
  // List<Profile> allFriends = [
  //   Profile(userName: "rajiv45",
  //       phoneNum: "555-1234",
  //       country: "Bahamas",
  //       city: "Nassau"
  //   ),
  //   Profile(userName: "fab",
  //       phoneNum: "555-1235",
  //       country: "Canada",
  //       city: "Ottawa"
  //   ),
  //   Profile(userName: "john_doe",
  //       phoneNum: "555-1237",
  //       country: "England",
  //       city: "Liverpool"
  //   ),
  // ];
  List<Profile> allFriends = [];

  //For search metric
  String userNameEntered = "";
  var _model = UserModel();
  //Todo: change currentUser to actual logged in user
  String userName = "rajiv45";
  Profile currentUser = Profile();
  late Stream friendListStream;

  @override
  void initState(){
    super.initState();

    //_getCurrentUser();
    friendListStream = _model.getAllFriends(currentUser);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        actions: [
          IconButton(
              onPressed: (){
                //Call async function that goes to route "/home"
                Navigator.pushNamed(context, '/home');
              },
              tooltip: 'Home',
              icon: const Icon(Icons.home)
          ),
        ],
      ),
      body: Column(
        children: [
          TextFormField(
          style: TextStyle(fontSize: 30),
            decoration: const InputDecoration(
                label: Text("Search"),
                hintText: "john123"
            ),
            onChanged: (value){
              setState(() {
                userNameEntered = value;
              });
            }
          ),
          StreamBuilder(
            stream: friendListStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              print("Snapshot: $snapshot");
              if(!snapshot.hasData){
                print("Data is missing from friendsList");
                return CircularProgressIndicator();
              }
              else{
                print("Found data for friendsList");

                // Updating list of all grades (used for logic purposes)
                allFriends = snapshot.data.docs.map<Profile>((document) =>
                    _model.getUserBySnapshot(context, document)
                ).toList();

                return Container (
                  height: 526,
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: allFriends.length,
                      itemBuilder: (context,index){
                        return Container(
                          // decoration: BoxDecoration(color: gradeColors[index]),
                            padding: const EdgeInsets.all(10.0),

                            child: ListTile(
                              title: Text("${allFriends[index].userName}",
                                style: const TextStyle(fontSize: 30),),
                              subtitle: Text("${allFriends[index].country}",
                                style: TextStyle(fontSize: 30),
                              ),
                              trailing: GestureDetector(
                                  child: const Icon(Icons.delete),
                                  onTap: (){
                                    //currently selected friend
                                    Profile user = allFriends[index];
                                    //open dialog
                                    _showDeleteFriendAlert(context,user);
                                  }
                              ),
                            )
                        );
                      }
                  ),
                );
              }
            }
          ),
        ],
      ),




      floatingActionButton: FloatingActionButton(
        onPressed: _addFriend,
        tooltip: 'Add Friend',
        child: const Icon(Icons.add),
      ),
    );
  }
  Future<void> _addFriend() async{
    Profile? friend = await Navigator
        .pushNamed(context, '/addFriend') as Profile?;

    if(friend != null){
      //send user a notification

      //Snackbar: Just added ${friend.userName}
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Just added ${friend.userName} as a friend :)",
                style: const TextStyle(fontSize: 20),)
          )
      );
    }




    //_getAllFriends();

  }

  // Future _getCurrentUser() async{
  //   currentUser = await _model.getUserByUsername(userName);
  // }

  _deleteFriend(Profile user){
    //Todo: remove friend from local storage

    //allFriends.remove(user);
    user.reference!.delete();

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Deleted ${user.userName} as a friend :(",
              style: const TextStyle(fontSize: 20),)
        )
    );

  }

  /*
  * Shows a Dialog confirming whether the user
  * wants to delete a friend.
  * */
  _showDeleteFriendAlert(BuildContext context, Profile user){
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Delete Friend"),
            content: Text("Are you sure you want to delete "
                "${user.userName}?"),
            actions: [
              TextButton(
                  onPressed: (){
                    setState(() {
                      _deleteFriend(user);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Yes")
              ),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: const Text("No")
              )
            ],
          );
        }
    );
  }
}
