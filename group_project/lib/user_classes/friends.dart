import 'package:flutter/material.dart';
import 'profile.dart';

class FriendList extends StatefulWidget {
  const FriendList({Key? key,this.title}) : super(key: key);

  final String? title;

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  //Todo: Get allFriends from local storage
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
                        style: const TextStyle(fontSize: 30),),
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
      //insert friend to local database

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

  _deleteFriend(Profile user){
    //Todo: remove friend from local storage

    allFriends.remove(user);

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
