import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/genre.dart';
import '../models/genre_model.dart';
import '../models/profile.dart';
import '../models/userModel.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  List<Profile> myProfile = [];
  String? currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  final _model = UserModel();
  Profile currentUser = Profile();
  var db = GenreModel();
  var _lastInsertedGenre;
  var allGenres = [];
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Column(
        children: [
          CircleAvatar(
            child: Text("AP"),
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
  getCurrentUser(String email)async{
    currentUser = await _model.getUserByEmail(email);
  }

  Future _addGenre() async{
    Genre newGenre = await Navigator.pushNamed(context, '/addGenre') as Genre;
    print(newGenre);
      _lastInsertedGenre = await db.insertGenre(newGenre);
    setState(() {
      getGenres();
    });
  }

  Future getGenres() async{
    allGenres = await db.getAllGenres();
    setState(() {
      allGenres;
    });
  }
}
