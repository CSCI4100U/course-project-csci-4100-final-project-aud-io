/*
* Author: Alessandro Prataviera
* */

import 'package:flutter/material.dart';
import 'package:group_project/MainScreen_Views/custom_circular_progress_indicator.dart';
import '../models/genre.dart';
import '../models/genre_model.dart';
import '../models/profile.dart';
import '../models/user_model.dart';
import 'package:group_project/MainScreen_Model/nav.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key, required this.title, this.otherUserEmail}) : super(key: key);
  final String? title;
  final String? otherUserEmail;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  List<Profile> myProfile = [];
  late String? currentUserEmail;
  final _model = UserModel();
  Profile userBeingViewed = Profile();
  var db = GenreModel();
  var allGenres = [];
  var _lastInsertedGenre;
  var selectedIndex = -1;
  var genresLength;


  @override
  void initState(){
    super.initState();
    if(widget.otherUserEmail != null){
      currentUserEmail = widget.otherUserEmail;
      getCurrentUser(currentUserEmail!);
    }
    else{
      userBeingViewed = currentUser;
    }
    getGenres();
    genresLength = allGenres.length;
  }


  @override
  Widget build(BuildContext context) {
    if(userBeingViewed.userName!=null){
      return Scaffold(
        appBar: buildAppBarForSubPages(context, widget.title!),
        body: Column(
          children: [
            CircleAvatar(
              child: Text(userBeingViewed.userName![0].toUpperCase(),
              style: TextStyle(fontSize: 30),),
              radius: 50,
            ),
            Container(
              child: ListTile(
                title: Text("username: ${userBeingViewed.userName}"),
                trailing: IconButton(onPressed: (){}, icon: const Icon(Icons.edit)),
              ),
            ),
            Container(
              child: ListTile(
                title: Text("email: ${userBeingViewed.email}"),
                trailing: IconButton(onPressed: (){}, icon: const Icon(Icons.edit)),
              ),
            ),
            Flexible(
                child: ListView.builder(
                    itemCount: allGenres.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: selectedIndex == index ? Colors.blue : null,
                        ),
                        child: GestureDetector(
                          child: ListTile(
                            title: Text('${allGenres[index].genre}'),
                          ),
                          onTap: () {
                            setState(() {
                              if(selectedIndex == index) {
                                selectedIndex = -1;
                              } else {
                                selectedIndex = index;
                              }
                            });
                          },
                        ),
                      );
                    }
                )
            ),
            Container(
                child: ListTile(
                  title: const Text("Add Favourite Genre"),
                  trailing: ElevatedButton(
                      onPressed: _addGenre,
                      child: const Text("Add")
                  ),
                )
            ),
          ],
        ),
      );
    }
    else{
      return const CustomCircularProgressIndicator();
    }

  }
  getCurrentUser(String email)async{
    userBeingViewed = await _model.getUserByEmail(email);
    setState(() {
      print("USER BEING VIEWED: $userBeingViewed");
    });
  }

  Future _addGenre() async{
    Genre newGenre = await Navigator.pushNamed(context, '/addGenre') as Genre;
    print(newGenre);
      _lastInsertedGenre = await db.insertGenre(newGenre);
    setState(() {
      getGenres();
    });
  }

  getGenres() async{
    allGenres = await db.getAllGenres();
    setState(() {});
  }
}
