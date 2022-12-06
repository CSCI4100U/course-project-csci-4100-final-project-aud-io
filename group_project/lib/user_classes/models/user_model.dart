/*
* Author: Rajiv Williams
* */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:group_project/user_classes/models/utils.dart';
import 'package:group_project/user_classes/views/profile_view.dart';
import 'dart:async';
import '../../music_classes/models/fav_genre.dart';
import 'profile.dart';
import 'package:latlong2/latlong.dart';

Profile currentUser = Profile();

class UserModel{
  static initializeCurrentUser() async{
    print("Initializing current user...");
    if(FirebaseAuth.instance.currentUser != null){
      currentUser = await UserModel().getUserByEmail(FirebaseAuth.instance.currentUser!.email!);
    }

  }

  /*
  * Insert newly signed up user into database
  * */
  Future insertUser(Profile user) async{
    print("Adding new user...");
    // Add user to 'users' collection
    FirebaseFirestore.instance.collection('users').doc().set(user.toMap());
    
    // Make a friendsList collection for the user
    if(user.reference != null){
      FirebaseFirestore.instance.collection('users').doc(user.reference!.id)
          .collection('friendsList').add({});
    }


  }

  /*
  * Returns all users in database for addFriend query
  * */
  Stream getUserStream() async*{

    print("Getting the users...");
    yield await FirebaseFirestore.instance.collection('users').get();
  }

  /*
  * Returns a List of all users in cloud storage
  * */
  Future<List<Profile>> getAllUsers() async{
    QuerySnapshot users = await FirebaseFirestore.instance.collection('users').get();

    List<Profile> allUsers = users.docs.map<Profile>((document) {
      final user = Profile.fromMap(
          document.data(),
          reference: document.reference);
      return user;
    }).toList();

    return allUsers;
  }

  /*
  * Function return a Profile given an
  * email, which is then compared with
  * the email in the users under
  * Firebase Authentication.
  * */
  Future<Profile> getUserByEmail(String email) async{
    Profile result = Profile();
    List<Profile> allUsers = await getAllUsers();
    for(Profile user in allUsers){
      if(user.email == email){
        return user;
      }
    }
    return result;
  }


  /*
  * Returns all friends in database for a specific user
  * */
  Stream getFriendStream(Profile user) async*{

    print("Getting the friendsList...");
    if(user.reference!=null){
      yield await FirebaseFirestore.instance.collection('users').doc(user.reference!.id)
          .collection('friendsList').get();
    }

  }

  /*
  * Function returns friendsList (List<Profile>)
  * of given a user.
  * */
  Future<List<Profile>> getFriendsList(Profile user) async{

    if(user.reference != null) {
      QuerySnapshot friends = await FirebaseFirestore.instance.collection(
          'users')
          .doc(user.reference!.id).collection('friendsList').get();

      List<Profile> allFriends = friends.docs.map<Profile>((user) {
        final friend = Profile.fromMap(
            user.data(),
            reference: user.reference);
        return friend;
      }).toList();

      return allFriends;
    }
    return [];
  }

  /*
  * Insert friend into the givem user's friendsList
  * */
  Future addToFriendList(Profile user, Profile friend) async{
    print("Adding '${friend.userName}' to ${user.userName}'s friendsList...");
    FirebaseFirestore.instance.collection('users')
        .doc(user.reference!.id).collection('friendsList').doc().set(friend.toMap());


  }

  Future updateUser(Profile user) async{
    print("Updating user info...");
    FirebaseFirestore.instance.collection('users').doc(user.reference!.id).update(user.toMap());
  }

  Future deleteUser(Profile user) async{
    user.reference!.delete();
  }

  /*
  * Function returns an individual user from a snapshot
  * */
  Profile getUserBySnapshot(BuildContext context, DocumentSnapshot userData){
    final user = Profile.fromMap(
        userData.data(),
        reference: userData.reference);
    return user;
  }

  /*
  * Returns user Avatar based on whether or not
  * they have a profile picture
  * */
  Widget buildUserAvatar(Profile user, BuildContext context){
    //Todo: Make variable to hold profile picture for each user

    return GestureDetector(
      child:
      Container(
        padding: EdgeInsets.all(10),
        child: CircleAvatar(
          backgroundColor: Colors.black,
          radius: 25,
          //Todo: Replace with profile photo
          child: Text(user.userName![0].toUpperCase()),
        ),
      ),
      onTap: (){
        // go to profile page of friend
        if(!isCurrentUser(user)){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileView(
                title: "${user.userName}'s ${FlutterI18n.translate(context, "titles.profile")}",
                otherUserEmail: "${user.email}",
              ))
          );
        }
      },
    );
  }

  isCurrentUser(Profile user){
    return user.userName == currentUser.userName;
  }

  updateFavGenres(List<dynamic> allGenres){
    List<String> genres = [];
    for(FavGenre genre in allGenres){
      genres.add(genre.genre!.toUpperCase());
    }
    currentUser.favGenres = genres;
    UserModel().updateUser(currentUser);
  }
}