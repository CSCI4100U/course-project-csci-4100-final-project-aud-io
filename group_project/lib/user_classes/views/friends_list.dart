import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendList extends StatefulWidget {
  const FriendList({Key? key,this.title}) : super(key: key);

  final String? title;

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {

  List<Profile> allFriends = [];
  TextStyle style = const TextStyle(fontSize: 30);

  final _model = UserModel();
  Profile currentUser = Profile();
  String? currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  late Stream friendListStream;

  @override
  void initState(){
    super.initState();

    friendListStream = _model.getFriendStream(currentUser);
    getCurrentUser(currentUserEmail!);
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

                if(allFriends.isNotEmpty){
                  return Expanded(
                    child: Container (
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: allFriends.length,
                          itemBuilder: (context,index){
                            return Container(
                              // decoration: BoxDecoration(color: gradeColors[index]),
                                padding: const EdgeInsets.all(10.0),

                                child: ListTile(
                                  title: Text("${allFriends[index].userName}",
                                    style: style,
                                  ),
                                  subtitle: Text("${allFriends[index].country}",
                                    style: style,
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
                    ),
                  );
                }
                else{
                  return Container(
                    // decoration: BoxDecoration(color: gradeColors[index]),
                      padding: const EdgeInsets.all(10.0),

                      child: Text("Looks like you have no friends :(",
                        style: style,
                      )
                  );
                }

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

    if(friend != null && friend.userName != null){
      //send user a notification

      //Snackbar: Just added ${friend.userName}
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Just added ${friend.userName} as a friend :)",
                style: const TextStyle(fontSize: 20),)
          )
      );
    }
  }

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

  getCurrentUser(String email)async{
    currentUser = await _model.getUserByEmail(email);
    setState(() {
      friendListStream = _model.getFriendStream(currentUser);
      getAllFriends();
    });
  }

  getAllFriends() async{
    allFriends = await _model.getFriendsList(currentUser);
  }
}


