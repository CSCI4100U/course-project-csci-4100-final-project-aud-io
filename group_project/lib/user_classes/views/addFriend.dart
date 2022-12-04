/*
* Author: Rajiv Williams
* */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/MainScreen_Views/custom_circular_progress_indicator.dart';
import '../../MainScreen_Model/nav.dart';
import '../models/profile.dart';
import '../models/user_model.dart';

class AddFriendSearch extends StatefulWidget {
  AddFriendSearch({Key? key, this.title, required this.userNameEntered}) : super(key: key);

  String? title;
  String userNameEntered;

  @override
  State<AddFriendSearch> createState() => _AddFriendSearchState();
}

class _AddFriendSearchState extends State<AddFriendSearch> {
  var formKey = GlobalKey<FormState>();
  late String userNameEntered = widget.userNameEntered;
  final _model = UserModel();

  TextStyle style = TextStyle(fontSize: 30);

  List<Profile> allUsers = [];
  List<Profile> allFriends = [];
  late Stream userStream;

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
              style: TextStyle(fontSize: 30),
              decoration: const InputDecoration(
                  label: Text("Search username"),
                  hintText: "john123"
              ),
              onChanged: (value){
                setState(() {
                  userNameEntered = value;
                });
              }
          ),
          StreamBuilder(
              stream: userStream,
              builder: (BuildContext context,AsyncSnapshot snapshot){
                print("Snapshot: $snapshot");
                if(!snapshot.hasData){
                  print("Data is missing from userList");
                  return const CustomCircularProgressIndicator();
                }
                else{
                  print("Found data for userList");

                  // users that meet the criteria of the query
                  List<Profile> usersFound = getUsersFound();

                  if(usersFound.isNotEmpty){
                    return Expanded(
                      child:
                        Container(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: usersFound.length,
                            itemBuilder: (context,index){

                              Profile userFound = usersFound[index];

                              return Row(
                                children: [
                                  _model.buildUserAvatar(userFound,context),
                                  Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ListTile(
                                            title: Text("${userFound.userName}",
                                              style: TextStyle(fontSize: 30),
                                            ),
                                            subtitle: Text("${userFound.country}",
                                              style: TextStyle(fontSize: 30),
                                            ),
                                            trailing: IconButton(
                                                onPressed: (){
                                                  setState(() {
                                                    Navigator.of(context).pop(userFound);
                                                  });
                                                },
                                                icon: Icon(Icons.person_add,size: 30,)
                                            )
                                        ),
                                      ),
                                  ),
                                ]
                              );
                            }
                          ),
                        ),
                    );
                  }
                  else{
                    if(userNameEntered == ""){
                      //Output nothing
                      return const Text("");
                    }
                    else{
                      return Expanded(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Text("No results found.",
                              style: style,
                            ),
                          )
                      );
                    }

                  }
                }
              }
          )
        ],
      ),
    );
  }

  // Updates widget with current users in cloud storage
  loadUsers(){
    setState(() {
      getAllFriends();
      getAllUsers();
    });
  }

  // Makes list of all users
  getAllUsers() async{
    userStream = _model.getUserStream();
    allUsers = await _model.getAllUsers();
  }

  getAllFriends() async{
    allFriends = await _model.getFriendsList(currentUser);
  }

  /*
  * Queries through users based on userNameEntered
  * */
  getUsersFound(){
    List<Profile> foundUsers = [];
    // Query through all users
    for(Profile user in allUsers){
      // if current user matches the userName entered
      if(user.userName != null && user.userName!.contains(userNameEntered)
          && user.userName != currentUser.userName && userNameEntered != ""){
        bool isFriend = false;
        for(Profile friend in allFriends){
          if(friend.userName == user.userName){
            isFriend = true;
          }
        }
        if(!isFriend){
          // Add user to foundUsers
          foundUsers.add(user);
        }
      }
    }
    return foundUsers;
  }
}