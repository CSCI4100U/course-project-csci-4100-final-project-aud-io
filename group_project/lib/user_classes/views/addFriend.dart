/*
* Author: Rajiv Williams
* */

import 'package:flutter/material.dart';
import 'package:group_project/mainScreen_classes/MainScreen_Views/custom_circular_progress_indicator.dart';
import '../../mainScreen_classes/MainScreen_Model/navigation_bar.dart';
import '../models/profile.dart';
import '../models/user_model.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:group_project/mainScreen_classes/MainScreen_Model/app_constants.dart';

/*
* Class iterates through the Firebase database given the username entered
* */
class AddFriendSearch extends StatefulWidget {
  const AddFriendSearch({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<AddFriendSearch> createState() => _AddFriendSearchState();
}

class _AddFriendSearchState extends State<AddFriendSearch> {
  var formKey = GlobalKey<FormState>();
  String userNameEntered = "";
  final _model = UserModel();
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
              style: style,
              decoration: InputDecoration(
                  label: Text(FlutterI18n.translate(context, "forms.search")),
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
                        ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: usersFound.length,
                          itemBuilder: (context,index){

                            Profile userFound = usersFound[index];

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
                                  _model.buildUserAvatar(userFound,context),
                                  Expanded(
                                      child: Container(
                                        padding: padding,
                                        child: ListTile(
                                            title: Text("${userFound.userName}",
                                              style: style,
                                            ),
                                            subtitle: Text("${userFound.country}",
                                              style: style,
                                            ),
                                            trailing: IconButton(
                                                onPressed: (){
                                                  setState(() {
                                                    Navigator.of(context).pop(userFound);
                                                  });
                                                },
                                                icon: const Icon(Icons.person_add,size: 30,)
                                            )
                                        ),
                                      ),
                                  ),
                                ]
                              ),
                            );
                          }
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
                            padding: padding,
                            child: Text(
                              FlutterI18n.translate(context, "forms.texts.no_results"),
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