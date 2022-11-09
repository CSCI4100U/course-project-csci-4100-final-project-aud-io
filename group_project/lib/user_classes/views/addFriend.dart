import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../models/userModel.dart';

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

  TextStyle style = TextStyle(fontSize: 30);

  List<Profile> allUsers = [];
  Profile newFriend = Profile();
  late Stream userStream;

  @override
  void initState(){
    super.initState();

    userStream = _model.getUserStream();
    loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
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
                  return CircularProgressIndicator();
                }
                else{
                  print("Found data for userList");

                  List<Profile> foundUsers = [];

                  // Query through all users
                  for(Profile user in allUsers){

                    // if current user matches the userName entered
                    if(user.userName != null && user.userName!.contains(userNameEntered)){
                      // Add user to foundUsers
                      foundUsers.add(user);
                      print("User: $userNameEntered");
                      //Todo: Add if statement to check if user already in friendsList and not current user
                      // if friend already added, don't include in search results, etc.
                    }
                  }

                  if(foundUsers.isNotEmpty){
                    return
                        Expanded(
                          child:
                            Container(
                              child: ListView.builder(

                                  padding: const EdgeInsets.all(8.0),
                                  itemCount: foundUsers.length,
                                  itemBuilder: (context,index){
                                    return GestureDetector(
                                        child: Container(
                                          decoration: BoxDecoration(color: Colors.white),
                                          padding: const EdgeInsets.all(10.0),

                                          child: ListTile(
                                            title: Text("${foundUsers[index].userName}",
                                              style: TextStyle(fontSize: 30),
                                            ),
                                            subtitle: Text("${foundUsers[index].country}",
                                              style: TextStyle(fontSize: 30),
                                            ),
                                            /*
                                                    Todo:
                                        Make this add Icon, to add multiple users
                                        to a list to send all friend requests at once
                                       */
                                            // trailing:
                                          ),

                                        ),
                                        onTap: (){
                                          //show selected color

                                          //set this to newFriend to be added
                                          setState(() {
                                            newFriend = foundUsers[index];
                                          });


                                        }
                                    );
                                  }
                              ),
                            ),
                        );

                  }
                  else{
                    print("No results found.");
                    return CircularProgressIndicator();
                  }

                }
              }
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pop(newFriend);
        },
        tooltip: 'Add Friend',
        child: const Icon(Icons.person_add),
      ),
    );
  }

  // Updates widget with current users in cloud storage
  loadUsers(){
    setState(() {
      getAllUsers();
    });
  }

  // Makes list of all users
  getAllUsers() async{
    allUsers = await _model.getAllUsers();
  }
}