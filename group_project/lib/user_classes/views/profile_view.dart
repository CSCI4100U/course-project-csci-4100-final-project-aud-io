/*
* Author: Alessandro Prataviera
* */

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:group_project/MainScreen_Views/custom_circular_progress_indicator.dart';
import '../../MainScreen_Model/app_constants.dart';
import '../models/profile.dart';
import '../models/user_model.dart';
import 'package:group_project/MainScreen_Model/navigation_bar.dart';

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
    //getGenres();
  }


  @override
  Widget build(BuildContext context) {
    if(userBeingViewed.userName!=null){
      return Scaffold(
        appBar: buildAppBarForSubPages(context, FlutterI18n.translate(context, "titles.profile")),
        body: Column(
          children: [
            CircleAvatar(
              radius: 50,
              child: Text(userBeingViewed.userName![0].toUpperCase(),
                style: style,
              ),
            ),
            Container(
              child: ListTile(
                title: Text("${FlutterI18n.translate(context, "forms.username")}: ${userBeingViewed.userName}"),
              ),
            ),
            Container(
              child: ListTile(
                title: Text("${FlutterI18n.translate(context, "forms.email")}: ${userBeingViewed.email}"),
              ),
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
}
