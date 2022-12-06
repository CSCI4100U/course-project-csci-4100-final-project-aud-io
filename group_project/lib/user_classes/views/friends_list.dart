/*
* Author: Rajiv Williams
* */

import 'package:flutter/material.dart';
import '../../MainScreen_Model/app_constants.dart';
import '../../MainScreen_Views/custom_circular_progress_indicator.dart';
import '../models/profile.dart';
import '../models/user_model.dart';
import 'package:group_project/MainScreen_Model/navigation_bar.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../models/utils.dart';

class FriendList extends StatefulWidget {
  const FriendList({Key? key,this.title,this.userFromExplore}) : super(key: key);

  final String? title;
  final Profile? userFromExplore;

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {

  List<Profile> allFriends = [];

  final _model = UserModel();
  late Stream friendListStream;

  @override
  void initState(){
    super.initState();
    if(widget.userFromExplore != null){
      _addFriend(widget.userFromExplore);
    }
    friendListStream = _model.getFriendStream(currentUser);
    loadFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarForSubPages(context, widget.title!),
      body: Column(
        children: [
          StreamBuilder(
            stream: friendListStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              print("Snapshot: $snapshot");
              if(!snapshot.hasData){
                print("Data is missing from friendsList");
                return const CustomCircularProgressIndicator();
              }
              else{
                print("Found data for friendsList");

                if(allFriends.isNotEmpty){
                  return Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: allFriends.length,
                        itemBuilder: (context,index){

                          Profile currentFriend = allFriends[index];

                          return Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 1
                                  )
                                ]
                            ),
                            child: Row(
                                children: [
                                  _model.buildUserAvatar(currentFriend,context),
                                  Expanded(
                                      child: Container(
                                          padding: padding,
                                          child: ListTile(
                                            title: Text("${currentFriend.userName}",
                                              style: style,
                                            ),
                                            subtitle: Text("${currentFriend.country}",
                                              style: style,
                                            ),
                                            trailing: IconButton(
                                              highlightColor: const Color.fromRGBO(118, 149, 255, 1),
                                                onPressed: (){
                                                  //open delete dialog for currentFriend
                                                  _showDeleteFriendAlert(context,currentFriend);
                                                },
                                                icon: const Icon(Icons.person_remove,size: 30,),
                                            ),
                                          )
                                      ),
                                  )
                                ],

                            ),
                          );
                        }
                    ),
                  );
                }
                else{
                  return Container(
                      padding: padding,
                      child: Text(
                        FlutterI18n.translate(context, "forms.texts.no_friend"),
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
        onPressed: (){
          _addFriend(Profile());
        },
        tooltip: 'Add Friend',
        child: const Icon(Icons.person_add_alt_1),
      ),
    );
  }

  /*
  * Function takes the friend added from the
  * addFriend page and adds it to the current user's
  * friendsList and subsequently adds the current user
  * to the other user's friendsList
  * */
  Future<void> _addFriend(Profile? friend) async{
    friend = await Navigator
        .pushNamed(context, '/addFriend') as Profile?;
    if(friend != null && friend.userName != null){
      //Todo: send friend a notification to add

      //For the time being, add them to friendsList
      _model.addToFriendList(currentUser, friend);

      //Add current user to friend's friendsList
      _model.addToFriendList(friend, currentUser);

      loadFriends();

      Utils.showSnackBar("Just added ${friend.userName} as a friend :)",Colors.black);
    }
  }

  /*
  * Function deletes a given Profile from the
  * current user's friendsList and subsequently
  * deletes themselves from the other user's friendsList
  * */
  _deleteFriend(Profile friend) async{
    //delete user from currentUser's friendList
    friend.reference!.delete();
    getAllFriends();

    //delete currentUser from their friendList
    List<Profile> allUsers = await _model.getAllUsers();
    for(Profile profile in allUsers){
      //If profile of friend exists in users
      if(profile.reference != null && profile.userName == friend.userName){
        List<Profile> usersFriends = await _model.getFriendsList(profile);
        for(Profile userToDelete in usersFriends){

          //If userToDelete is found in friendsList
          if(userToDelete.reference != null && userToDelete.userName == currentUser.userName) {
            print("User being deleted from ${profile.userName}'s friendsList: $userToDelete : ${userToDelete.reference!.id}");
            userToDelete.reference!.delete();
          }
        }
      }
    }
    Utils.showSnackBar("Deleted ${friend.userName} as a friend :(",Colors.black);
  }

  /*
  * Function shows a snackBar given a
  * string content
  * */
  // showSnackBar(String content){
  //   ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text(content,
  //             style: const TextStyle(fontSize: 20),)
  //       )
  //   );
  // }

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
            title: const Text("Remove Friend?"),
            content: Text("${user.userName}"),
            actions: [
              TextButton(
                  onPressed: (){
                    setState(() {
                      _deleteFriend(user);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Remove")
              ),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")
              )
            ],
          );
        }
    );
  }

  /*
  * Function rebuilds the widget based on the
  * reloading of the getAllFriends() function
  * */
  loadFriends(){
    setState(() {
      getAllFriends();
    });
  }

  /*
  * Function reloads friend stream and updates the
  * List of all the friends of the current user
  * */
  getAllFriends() async{
    friendListStream = _model.getFriendStream(currentUser);
    allFriends = await _model.getFriendsList(currentUser);
  }
}


