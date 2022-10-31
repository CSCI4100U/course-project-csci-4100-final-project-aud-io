import 'package:flutter/material.dart';
import 'profile.dart';

class FriendList extends StatefulWidget {
  const FriendList({Key? key,this.title}) : super(key: key);

  final String? title;

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  int selectedIndex = 0;
  List<Profile> allFriends = [
    Profile(userName: "rajiv45",
        phoneNum: "555-1234",
        country: "Bahamas",
        city: "Nassau"
    ),
    Profile(userName: "fab",
        phoneNum: "555-1235",
        country: "Canada",
        city: "Ottawa"
    ),
    Profile(userName: "john_doe",
        phoneNum: "555-1237",
        country: "England",
        city: "Liverpool"
    ),
  ];

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
      body: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: allFriends.length,
          itemBuilder: (context,index){
            return Container(
                  // decoration: BoxDecoration(color: gradeColors[index]),
                  padding: const EdgeInsets.all(10.0),

                  child: ListTile(
                      title: Text("${allFriends[index].userName}",
                        style: TextStyle(fontSize: 30),),
                      trailing: GestureDetector(
                          child: Icon(Icons.delete),
                          onTap: (){
                            Profile user = allFriends[index];
                            //open dialog
                            // "Are you sure you want to delete {user}"
                              _showDeleteFriendAlert(context,user);

                            },
                      ),

                  ),

                );
          }
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
  _deleteFriend(Profile user){
    //remove friend from local storage
    allFriends.remove(user);
  }

  _showDeleteFriendAlert(BuildContext context, Profile user){
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Delete Friend"),
            content: Text("Are you sure you want to delete ${user.userName}?"),
            actions: [
              TextButton(
                  onPressed: (){
                    setState(() {
                      _deleteFriend(user);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("Yes")
              ),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("No")
              )
            ],
          );
        }
    );
  }
}
