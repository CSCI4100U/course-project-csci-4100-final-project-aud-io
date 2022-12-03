/*
* Author: Alessandro Prataviera
* */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/MainScreen_Views/custom_circular_progress_indicator.dart';
import '../models/genre.dart';
import '../models/genre_model.dart';
import '../models/profile.dart';
import '../models/user_model.dart';
import 'package:group_project/MainScreen_Model/nav.dart';

class ProfileView extends StatefulWidget {
  ProfileView({Key? key, required this.title, required this.currentUserEmail}) : super(key: key);
  final String? title;
  final String? currentUserEmail;
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  List<Profile> myProfile = [];
  late String? currentUserEmail = widget.currentUserEmail;
  final _model = UserModel();
  Profile currentUser = Profile();
  var db = GenreModel();
  var allGenres = [];
  var _lastInsertedGenre;
  var selectedIndex = -1;
  var genresLength;


  @override
  void initState(){
    super.initState();
    getCurrentUser(currentUserEmail!);
    getGenres();
    genresLength = allGenres.length;
  }


  @override
  Widget build(BuildContext context) {
    if(currentUser.userName!=null){
      return Scaffold(
        appBar: buildAppBarForSubPages(context, widget.title!),
        body: Column(
          children: [
            CircleAvatar(
              child: Text(currentUser.userName![0].toUpperCase()),
            ),
            Container(
              child: ListTile(
                title: Text("email: ${currentUser.email}"),
                trailing: IconButton(onPressed: (){}, icon: const Icon(Icons.edit)),
              ),
            ),
            Container(
              child: ListTile(
                title: Text("username: ${currentUser.userName}"),
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
    currentUser = await _model.getUserByEmail(email);
    setState(() {
      print("CURRENT USER: $currentUser");
      currentUser;
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

    setState(() {
      allGenres;
    });
  }
}
