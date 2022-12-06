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
  late Profile userBeingViewed = Profile();
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
  }
  String? phoneNum;
  String? country;
  String? city;
  String? email;
  String? birthday;

  @override
  Widget build(BuildContext context) {
    if(userBeingViewed.userName!=null){
      List<String> translations = [
        "forms.username",
        "forms.email",
        "forms.city",
        "forms.country",
        "forms.phone",
        "forms.buttons.birthday",
        "forms.favGenres"
      ];
      Map<String,String> userInformation = {
        translations[0]:userBeingViewed.userName!,
        translations[1]:userBeingViewed.email!,
        translations[2]:userBeingViewed.city!,
        translations[3]:userBeingViewed.country!,
        translations[4]:userBeingViewed.phoneNum!,
        translations[5]:userBeingViewed.birthday!,
        translations[6]:userBeingViewed.favGenres!= null && userBeingViewed.favGenres.toString().isNotEmpty
            ? userBeingViewed.favGenres!.toString()
            : FlutterI18n.translate(context, "forms.texts.none"),
      };
      return Scaffold(
        appBar: buildAppBarForSubPages(context, widget.title!),
        body: Column(
          children: [
            Expanded(
              flex: 1,
                child: CircleAvatar(
                  radius: 50,
                  child: Text(userBeingViewed.userName![0].toUpperCase(),
                    style: style,
                  ),
                ),
            ),
            Expanded(
              flex: 4,
              child: ListView.builder(
                  itemCount: userInformation.length,
                  itemBuilder: (context,index){
                return Container(
                    padding: padding,
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
                        Expanded(
                            child: Text("${FlutterI18n.translate(context, translations[index])
                                .toUpperCase()}:",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize-5,
                              ),
                              textAlign: TextAlign.center,
                            )
                        ),
                        Expanded(
                            flex: 2,
                            child: Text(userInformation[translations[index]]!,
                              style: const TextStyle(fontSize: fontSize-5),
                            )
                        )
                      ],
                    )
                );
              }),
            )
            // Container(
            //     padding: padding,
            //   decoration: BoxDecoration(
            //       color: Colors.white,
            //       boxShadow: [
            //         BoxShadow(
            //             blurRadius: 1
            //         )
            //       ]
            //   ),
            //   child: Row(
            //     children: [
            //       Expanded(
            //           child: Text("${FlutterI18n.translate(context, "forms.username")
            //               .toUpperCase()}:")
            //       ),
            //       Expanded(
            //           child: Text(userBeingViewed.userName!)
            //       )
            //     ],
            //   )
            // ),
            // Container(
            //     padding: padding,
            //     decoration: BoxDecoration(
            //         color: Colors.white,
            //         boxShadow: [
            //           BoxShadow(
            //               blurRadius: 1
            //           )
            //         ]
            //     ),
            //     child: Row(
            //       children: [
            //         Expanded(
            //             child: Text("${FlutterI18n.translate(context, "forms.email").toUpperCase()
            //                 .toUpperCase()}:")
            //         ),
            //         Expanded(
            //             child: Text(userBeingViewed.email!)
            //         )
            //       ],
            //     )
            // ),
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
